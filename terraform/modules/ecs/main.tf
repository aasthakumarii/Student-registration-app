resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Create CloudWatch Log Group FIRST
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/student-app"
  retention_in_days = 7

  tags = {
    Name = "student-app-logs"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "demoapp" {
  family                   = var.task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = var.cpu
  memory = var.memory

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  # Ensure log group exists before task definition
  depends_on = [aws_cloudwatch_log_group.ecs_logs]

  container_definitions = jsonencode([
    {
      name      = "mysql"
      image     = var.mysql_image
      essential = true

      healthCheck = {
        command = [
          "CMD-SHELL",
          "mysqladmin ping -h 127.0.0.1 -u root -p$MYSQL_ROOT_PASSWORD || exit 1"
        ]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 80
      }

      environment = [
        { name = "MYSQL_ROOT_PASSWORD", value = var.root_pass },
        { name = "MYSQL_DATABASE", value = var.mysql_db },
        { name = "MYSQL_USER", value = var.mysql_user },
        { name = "MYSQL_PASSWORD", value = var.mysql_pass }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "mysql"
        }
      }
    },

    {
      name      = "backend"
      image     = var.backend_image
      essential = true

      dependsOn = [
        {
          containerName = "mysql"
          condition     = "HEALTHY"
        }
      ]

      environment = [
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_USER", value = var.db_user },
        { name = "DB_PASSWORD", value = var.db_pass },
        { name = "DB_NAME", value = var.db_name },
        { name = "PORT", value = "5000" },
        { name = "DB_CONNECT_RETRIES", value = "50" },
        { name = "DB_CONNECT_RETRY_DELAY_MS", value = "3000" }
      ]

      portMappings = [
        {
          containerPort = 5000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "backend"
        }
      }
    },

    {
      name      = "frontend"
      image     = var.frontend_image
      essential = true

      dependsOn = [
        {
          containerName = "backend"
          condition     = "START"
        }
      ]

      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "frontend"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "demo_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.demoapp.arn

  desired_count = var.desired_count
  launch_type   = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecs_task_definition.demoapp,
    aws_cloudwatch_log_group.ecs_logs
  ]

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}
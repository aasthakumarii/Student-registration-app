resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/student-registration"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "main" {
  name = "student-cluster"
}

resource "aws_iam_role" "ecs_execution_role" {

  name_prefix = "student-ecs-execution-role-"

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

resource "aws_iam_role_policy_attachment" "ecs_execution" {

  role = aws_iam_role.ecs_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "student" {

  family                   = "student-registration"
  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu    = 1024
  memory = 2048

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "mysql-student"
      image     = "mysql:8.0"
      essential = true

      environment = [
        {
          name  = "MYSQL_ROOT_PASSWORD"
          value = "password123"
        },
        {
          name  = "MYSQL_DATABASE"
          value = "student_registration"
        }
      ]

      portMappings = [
        {
          containerPort = 3306
          protocol      = "tcp"
        }
      ]

      healthCheck = {
        command = [
          "CMD-SHELL",
          "mysqladmin ping -h 127.0.0.1 -uroot -p$MYSQL_ROOT_PASSWORD || exit 1"
        ]
        interval    = 10
        timeout     = 5
        retries     = 10
        startPeriod = 30
      }

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "mysql"
        }
      }
    },
    {
      name      = "backend-student"
      image     = var.backend_image
      essential = true

      dependsOn = [
        {
          containerName = "mysql-student"
          condition     = "HEALTHY"
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = "127.0.0.1"
        },
        {
          name  = "DB_USER"
          value = "root"
        },
        {
          name  = "DB_PASSWORD"
          value = "password123"
        },
        {
          name  = "DB_NAME"
          value = "student_registration"
        },
        {
          name  = "DB_CONNECT_RETRIES"
          value = "30"
        }
      ]

      portMappings = [
        {
          containerPort = 5000
          protocol      = "tcp"
        }
      ]

      healthCheck = {
        command = [
          "CMD-SHELL",
          "node -e \"fetch('http://127.0.0.1:5000/api/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))\""
        ]
        interval    = 10
        timeout     = 5
        retries     = 5
        startPeriod = 20
      }

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "backend"
        }
      }
    },
    {
      name      = "frontend-student"
      image     = var.frontend_image
      essential = true

      dependsOn = [
        {
          containerName = "backend-student"
          condition     = "HEALTHY"
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
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "frontend"
        }
      }
    }
  ])

  depends_on = [
    aws_cloudwatch_log_group.ecs,
    aws_iam_role_policy_attachment.ecs_execution
  ]
}

resource "aws_ecs_service" "student" {

  name = "student-service"

  cluster = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.student.arn

  desired_count = 0

  launch_type = "FARGATE"

  network_configuration {

    subnets = var.subnet_ids

    security_groups = [
      var.security_group_id
    ]

    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }
}

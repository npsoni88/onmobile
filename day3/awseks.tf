module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.17"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  tags = {
    env = "prod"
  }

  worker_groups = [
    {
      name = "worker-group-1"      
      instance_type = "t2.small"
      asg_max_size  = 2
      additional_security_groups = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name = "worker-group-2"
      instance_type = "t2.medium"
      asg_max_size  = 2
      additional_security_groups = [aws_security_group.worker_group_mgmt_two.id]

    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}


project_id = "thumperq-416219"
region  = "us-west1"
zone    = ["us-west1-a", "us-west1-b", "us-west1-c"]
gke_num_nodes = 1 # 3 zones 1 Node each = 3 Nodes(if you set it to 3, it will be 3 nodes in each zone["us-west1-a", "us-west1-b", "us-west1-c"], 9 nodes in total)
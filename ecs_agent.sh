sudo apt-get update &&
sudo apt-get install -y docker.io&&
sudo sh -c "echo 'net.ipv4.conf.all.route_localnet = 1' >> /etc/sysctl.conf"&&
sudo sysctl -p /etc/sysctl.conf&&
sudo iptables -t nat -A PREROUTING -p tcp -d 169.254.170.2 --dport 80 -j DNAT --to-destination 127.0.0.1:51679&&
sudo iptables -t nat -A OUTPUT -d 169.254.170.2 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 51679&&
sudo mkdir -p /etc/iptables/&&
sudo sh -c 'iptables-save > /etc/iptables/rules.v4'&&
sudo mkdir -p /etc/ecs && sudo touch /etc/ecs/ecs.config&&
sudo mkdir -p /var/log/ecs /var/lib/ecs/data&&
sudo docker run --name ecs-agent \
--detach=true \
--restart=on-failure:10 \
--volume=/var/run:/var/run \
--volume=/var/log/ecs/:/log \
--volume=/var/lib/ecs/data:/data \
--volume=/etc/ecs:/etc/ecs \
--net=host \
--env-file=/etc/ecs/ecs.config \
amazon/amazon-ecs-agent:latest

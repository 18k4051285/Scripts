#!/bin/bash

install_docker() {
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    sudo docker run hello-world:latest
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo newgrp docker
    docker run hello-world:latest
}

ping_1_1_1_1() {
    echo "Pinging 1.1.1.1..."
    ping -c 4 1.1.1.1
}
run_grafana_prometheus_docker(){
    docker run -d -p 3000:3000 --name grafana grafana/grafana-oss
    read -p 'Path prometheus.yml: ' path_pro
    Docker run -d -p 9090:9090 -v $path_pro/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus 

}
install_node_exporter(){
    wget https://github.com/prometheus/node_exporter/releases/download/v*/node_exporter-*.*-amd64.tar.gz
    tar xvfz node_exporter-*.*-amd64.tar.gz
    sudo mv node_exporter-*.*-amd64/node_exporter /usr/local/bin/
    sudo useradd -rs /bin/false node_exporter
    cat <<EOF > /etc/systemd/system/node_exporter.service
        [Unit]
        Description=Node Exporter
        After=network.target

        [Service]
        User=node_exporter
        Group=node_exporter
        Type=simple
        ExecStart=/usr/local/bin/node_exporter

        [Install]
        WantedBy=multi-user.target
EOF
    sudo systemctl daemon-reload
    sudo systemctl start node_exporter
    sudo systemctl enable node_exporter
    sudo systemctl status node_exporter

}

echo "Select an option:"
echo "1. Install Docker"
echo "2. Ping 1.1.1.1"
echo "3. Run Grafana & Prometheus"
echo "4. Install Node_Exporter"
read -p 'Choose Option: ' option

case $option in
    1)
        install_docker
        ;;
    2)
        ping_1_1_1_1
        ;;
    3)  
        run_grafana_prometheus_docker
        ;; 
    4)  
        install_node_exporter
        ;;
    *)
        echo "Invalid option. Exiting."
        ;;
esac

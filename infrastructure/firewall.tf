resource "google_compute_firewall" "http-firewall" {
    project = "${var.project}"
    name    = "${var.compute_instance_name}-allow-http"
    network = "${var.network}"

    allow {
        protocol = "tcp"
        ports    = ["80"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["${var.compute_instance_name}-http-firewall"]
}

resource "google_compute_firewall" "ssh-firewall" {
    project = "${var.project}"
    name    = "${var.compute_instance_name}-allow-ssh"
    network = "${var.network}"


    allow {
        protocol = "tcp"
        ports    = ["22"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["${var.compute_instance_name}-ssh-firewall"]
}

resource "google_compute_firewall" "https-firewall" {
    project = "${var.project}"
    name    = "${var.compute_instance_name}-allow-https"
    network = "${var.network}"

    allow {
        protocol = "tcp"
        ports    = ["443"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["${var.compute_instance_name}-https-firewall"]
}
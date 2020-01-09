resource "google_compute_firewall" "http-firewall" {
    project = "${var.project}"
    name    = "${var.environment}-allow-http"
    network = "${var.network}"

    allow {
        protocol = "tcp"
        ports    = ["80"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["${var.environment}-http-firewall"]
}

resource "google_compute_firewall" "ssh-firewall" {
    project = "${var.project}"
    name    = "${var.environment}-allow-ssh"
    network = "${var.network}"


    allow {
        protocol = "tcp"
        ports    = ["22"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["${var.environment}-ssh-firewall"]
}

resource "google_compute_firewall" "https-firewall" {
    project = "${var.project}"
    name    = "${var.environment}-allow-https"
    network = "${var.network}"

    allow {
        protocol = "tcp"
        ports    = ["443"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["${var.environment}-https-firewall"]
}
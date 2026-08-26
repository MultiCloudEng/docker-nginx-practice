# Docker Practice - Nginx Container

A minimal Docker setup that packages a custom static page into an nginx web server container.

## What this demonstrates
- Writing a Dockerfile from a base image (FROM)
- Copying custom content into a container (COPY)
- Exposing a port for web traffic (EXPOSE)
- Building an image and running it as a container
- Port mapping (host:container)

## Usage
```bash
docker build -t practice .
docker run -d -p 8080:80 practice
```
Then visit `http://localhost:8080`

## What I learned
Explored the nginx config inside the running container (`docker exec`) to understand
where nginx serves files from (`/usr/share/nginx/html`) and why the path in the
Dockerfile's COPY instruction matters.

## Skills
Docker, Dockerfile, nginx, containerization, image/container lifecycle.

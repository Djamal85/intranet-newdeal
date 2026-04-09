# Image de référence explicitement demandée par le sujet.
FROM nginx:alpine3.23 AS reference
RUN nginx -v

# Image finale légère imposée pour le runtime.
FROM nginx:alpine3.23-slim

LABEL org.opencontainers.image.title="intranet-newdeal" \
      org.opencontainers.image.description="Intranet institutionnel statique du Ministère de la Communication, des Télécommunications et du Numérique" \
      org.opencontainers.image.vendor="Djamal85" \
      org.opencontainers.image.licenses="CC-BY-3.0"

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY site/ /usr/share/nginx/html/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD wget -qO- http://127.0.0.1:80/ >/dev/null || exit 1

CMD ["nginx", "-g", "daemon off;"]

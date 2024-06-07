# Use the official postgres image with a specific version
FROM postgres:alpine

# Set metadata
LABEL maintainer=sh3b0

# Set environment variable for password
ENV POSTGRES_PASSWORD=postgres

# Create a directory for the SQL script (if not exists)
RUN mkdir -p /docker-entrypoint-initdb.d

# Copy the SQL script to the container
COPY init.sql /docker-entrypoint-initdb.d/

# Use an existing unpriveleged user
USER postgres

# Define the port that this container should listen on at runtime
EXPOSE 5432

# Run postgres in foreground mode (-d for background)
CMD ["postgres"]
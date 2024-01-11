# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install necessary packages
RUN apt-get update && \
    apt-get install -y vsftpd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a user for FTP access
RUN useradd -m ftpuser && \
    echo "ftpuser:palazzodjs" | chpasswd

# Create a directory to store FTP files
RUN mkdir /home/ftpuser/ftp

# Set permissions for the FTP directory
RUN chown ftpuser:palazzodjs /home/ftpuser/ftp

# Configure vsftpd
RUN echo "write_enable=YES" >> /etc/vsftpd.conf
RUN echo "local_enable=YES" >> /etc/vsftpd.conf
RUN echo "chroot_local_user=YES" >> /etc/vsftpd.conf

# Expose FTP port
EXPOSE 21

# Start vsftpd in the foreground
CMD ["vsftpd", "/etc/vsftpd.conf"]

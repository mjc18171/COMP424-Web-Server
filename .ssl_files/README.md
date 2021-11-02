How to migrate ssl certificates for Certbot to new server

Step 1 - Archive SSL certificates:
sudo tar -chvzf certs.tar.gz /etc/letsencrypt/archive/devicehealer.site /etc/letsencrypt/renewal/devicehealer.site.conf

Step 2 - Extract archive on new server
#since we have our archive file on github no need for scp
cd /
sudo tar -xvf ~/certs.tar.gz

Step 3 - Create symlinks
sudo ln -s /etc/letsencrypt/archive/devicehealer.site/cert2.pem /etc/letsencrypt/live/devicehealer.site/cert.pem
sudo ln -s /etc/letsencrypt/archive/devicehealer.site/chain2.pem /etc/letsencrypt/live/devicehealer.site/chain.pem
sudo ln -s /etc/letsencrypt/archive/devicehealer.site/fullchain2.pem /etc/letsencrypt/live/devicehealer.site/fullchain.pem
sudo ln -s /etc/letsencrypt/archive/devicehealer.site/privkey2.pem /etc/letsencrypt/live/devicehealer.site/privkey.pem

Step 5 - Configure your apache configurations

Step 6 - Test certificate renewal:
sudo letsencrypt renew --dry-run

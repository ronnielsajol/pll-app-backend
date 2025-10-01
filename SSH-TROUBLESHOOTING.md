# SSH Authentication Troubleshooting Guide

## 🚨 SSH Authentication Error Solutions

If you're getting `ssh: handshake failed: ssh: unable to authenticate`, here are the solutions:

## 🔧 Solution 1: Use SSH Key Authentication (Recommended)

### Step 1: Generate SSH Key Pair

**On your local machine:**

```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"

# When prompted, save it as: ~/.ssh/godaddy_rsa
# Leave passphrase empty for automation

# Copy the public key
cat ~/.ssh/godaddy_rsa.pub
```

### Step 2: Add Public Key to GoDaddy Server

**SSH into your GoDaddy server:**

```bash
ssh your-username@your-server-ip

# Create .ssh directory if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Add your public key to authorized_keys
nano ~/.ssh/authorized_keys
# Paste the content of godaddy_rsa.pub here

# Set proper permissions
chmod 600 ~/.ssh/authorized_keys
```

### Step 3: Add Private Key to GitHub Secrets

1. **Copy your private key:**

    ```bash
    cat ~/.ssh/godaddy_rsa
    ```

2. **Add to GitHub Secrets:**
    - Go to your GitHub repository
    - Settings → Secrets and Variables → Actions
    - Add `GODADDY_SSH_KEY` with the private key content

### Step 4: Update GitHub Secrets

Add these secrets in your GitHub repository:

| Secret Name            | Value               | Example                              |
| ---------------------- | ------------------- | ------------------------------------ |
| `GODADDY_HOST`         | Server IP or domain | `123.456.789.012`                    |
| `GODADDY_USERNAME`     | SSH username        | `your-username`                      |
| `GODADDY_SSH_KEY`      | Private key content | `-----BEGIN RSA PRIVATE KEY-----...` |
| `GODADDY_PORT`         | SSH port            | `22`                                 |
| `GODADDY_PROJECT_PATH` | Project path        | `/home/username/public_html/project` |

**Note:** Remove `GODADDY_PASSWORD` if using SSH key authentication.

## 🔧 Solution 2: Fix Password Authentication

If you prefer password authentication:

### Step 1: Verify GoDaddy SSH Settings

**Check if password authentication is enabled:**

```bash
# SSH into your server
ssh your-username@your-server-ip

# Check SSH config
sudo nano /etc/ssh/sshd_config

# Ensure these lines are set:
PasswordAuthentication yes
PubkeyAuthentication yes
AuthenticationMethods password publickey

# Restart SSH service
sudo systemctl restart sshd
```

### Step 2: Verify Credentials

**Test SSH connection manually:**

```bash
ssh -p 22 your-username@your-server-ip
```

If this fails, your credentials are incorrect.

### Step 3: Check GoDaddy Hosting Panel

1. **Verify SSH is enabled** in your hosting control panel
2. **Check username** - it might be different from your hosting username
3. **Reset SSH password** if needed

## 🔧 Solution 3: Alternative Deployment Methods

### Option A: FTP Deployment

If SSH continues to fail, you can use FTP deployment:

```yaml
- name: Deploy via FTP
  uses: SamKirkland/FTP-Deploy-Action@4.3.3
  with:
      server: ${{ secrets.FTP_HOST }}
      username: ${{ secrets.FTP_USERNAME }}
      password: ${{ secrets.FTP_PASSWORD }}
      local-dir: ./
      server-dir: /public_html/your-project/
```

### Option B: Manual Deployment

1. **Download your repository as ZIP**
2. **Upload via cPanel File Manager**
3. **Extract in your hosting directory**
4. **Run composer and artisan commands via SSH**

## 🔧 Solution 4: Debug SSH Connection

### Enable SSH Debug Mode

Update your workflow to get more details:

```yaml
- name: Test SSH Connection
  run: |
      ssh -vvv -p ${{ secrets.GODADDY_PORT }} \
          ${{ secrets.GODADDY_USERNAME }}@${{ secrets.GODADDY_HOST }} \
          "echo 'SSH connection successful'"
```

### Common SSH Issues

1. **Wrong port** - GoDaddy might use a different SSH port
2. **Firewall blocking** - Check if your IP is blocked
3. **Account suspended** - Verify hosting account status
4. **SSH disabled** - Some shared hosting plans disable SSH

## 🔧 Solution 5: Contact GoDaddy Support

If none of the above works:

1. **Verify SSH access** is included in your hosting plan
2. **Ask for SSH connection details** (correct port, username format)
3. **Request SSH troubleshooting** assistance

## ✅ Test Your Setup

Once configured, test with this simple command:

```bash
ssh -p YOUR_PORT YOUR_USERNAME@YOUR_HOST "pwd && whoami"
```

This should return your home directory path and username if successful.

## 📞 Quick Fixes

### Most Common Solutions:

1. ✅ Use SSH key instead of password
2. ✅ Verify correct SSH port (might not be 22)
3. ✅ Check username format (might need full email)
4. ✅ Ensure SSH is enabled in hosting panel
5. ✅ Try connecting from different IP/network

### Emergency Workaround:

If deployment is urgent, you can manually:

1. Download latest code from GitHub
2. Upload via cPanel File Manager
3. Run `composer install` and `php artisan migrate` via terminal

---

**Need help?** Check the [SETUP-CHECKLIST.md](SETUP-CHECKLIST.md) for more detailed instructions.

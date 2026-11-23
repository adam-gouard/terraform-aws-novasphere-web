#!/bin/bash
set -eu

dnf install -y nginx

install -d -m 700 /etc/${project}
SECRET_FILE=/etc/${project}/secret
STATUS="non"
FINGERPRINT=""

for i in 1 2 3 4 5 6 7 8 9 10; do
  if (umask 077; aws ssm get-parameter --name "${secret_path}" --with-decryption \
      --region "${region}" --query Parameter.Value --output text \
      > "$SECRET_FILE" 2>/dev/null); then
    STATUS="oui"
    break
  fi
  sleep 6
done

if [ "$STATUS" = "oui" ]; then
  FINGERPRINT=$(sha256sum "$SECRET_FILE" | cut -c1-8)
else
  rm -f "$SECRET_FILE"
fi

cat > /usr/share/nginx/html/index.html <<HTML
<!doctype html>
<html lang="fr">
<head><meta charset="utf-8"><title>${project} - ${environment}</title></head>
<body>
<h1>${project}</h1>
<p>Environnement : ${environment}</p>
<p>Instance : $(hostname)</p>
<p>Secret chargé : $STATUS $FINGERPRINT</p>
</body>
</html>
HTML

systemctl enable --now nginx
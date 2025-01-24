#!/bin/bash

BASE_URL="https://raw.githubusercontent.com/Lazy-Anonymity/mac-forger/refs/heads/main/src"
FILES=(
  "mac-forger:/usr/bin/mac-forger:755"
  "mac-forger.conf:/etc/mac-forger.conf:644"
  "mac-forger.service:/etc/systemd/system/mac-forger.service:644"
)

install_file() {
  local src_file="$1"
  local dest_path="$2"
  local permission="$3"

  echo "Baixando $src_file..."
  echo "$BASE_URL/$src_file"
  sudo curl -fsSL "$BASE_URL/$src_file" -o "$dest_path"
  if [[ $? -ne 0 ]]; then
    echo "Erro ao baixar $src_file. Abortando!"
    exit 1
  fi

  echo "Ajustando permissões para $permission..."
  chmod "$permission" "$dest_path"
}

for file_info in "${FILES[@]}"; do
  IFS=":" read -r src dest perm <<< "$file_info"
  install_file "$src" "$dest" "$perm"
done
sudo systemctl daemon-reload
sudo systemctl enable mac-forger.service
echo "Instalação concluída! Você pode iniciar o serviço com: sudo systemctl start mac-forger.service"

# Nix Darwin Configuration

Configuración modular de nix-darwin siguiendo principios SOLID para macOS.

## Estructura del Proyecto

```
/private/etc/nix-darwin/
├── flake.nix            # Configuración principal y entry point
├── homebrew.nix         # Homebrew integration (brews + casks)
├── user.nix             # Configuración de usuario
├── terminal.nix         # Terminal y shell (zsh)
├── network.nix          # Configuración de red
├── git.nix              # Git configuration
├── development.nix      # Herramientas de desarrollo
└── system.nix           # Preferencias del sistema macOS
```

## Módulos

### `flake.nix` - Configuración Principal

**Propósito:** Punto de entrada principal que orquesta todos los módulos.

**Contenido:**
- Inputs del flake (nixpkgs, nix-darwin)
- Configuración base del sistema
- Habilitación de experimental features (nix-command, flakes)
- Referencia a todos los módulos

**Comandos:**
```bash
# Aplicar configuración
darwin-rebuild switch --flake .#Andrews-MacBook

# Construir sin aplicar
darwin-rebuild build --flake .#Andrews-MacBook

# Ver changelog
darwin-rebuild changelog
```

---

### `homebrew.nix` - Homebrew Integration

**Propósito:** Gestión de paquetes vía Homebrew (útil para paquetes no disponibles en nixpkgs).

**Contenido:**
| Configuración | Descripción |
|---------------|-------------|
| `homebrew.enable` | Habilita integración con Homebrew |
| `homebrew.brews` | Lista de paquetes CLI |
| `homebrew.casks` | Lista de aplicaciones GUI |
| `homebrew.onActivation` | Comportamiento al activar |

**Ejemplo de uso:**
```nix
homebrew.brews = [ "git" "wget" "node" ];
homebrew.casks = [ "firefox" "visual-studio-code" "docker" ];
```

---

### `user.nix` - Configuración de Usuario

**Propósito:** Gestión de usuarios y configuración específica por usuario.

**Contenido:**
| Configuración | Descripción |
|---------------|-------------|
| `users.users.<name>` | Definición del usuario |
| `home` | Directorio home del usuario |
| `shell` | Shell por defecto |
| `home-manager` | Integración opcional con Home Manager |

**Configuración requerida:**
- Cambiar `andrew` por tu nombre de usuario real
- Verificar ruta del home directory

**Comandos útiles:**
```bash
# Ver usuario actual
whoami
```

---

### `terminal.nix` - Terminal y Shell

**Propósito:** Configuración del entorno de terminal y shell.

**Contenido:**
| Configuración | Descripción |
|---------------|-------------|
| `programs.zsh.enable` | Habilita zsh como shell |
| `programs.zsh.interactiveShellInit` |_aliases y configuraciones personalizadas_ |
| `programs.zsh.plugins` | Plugins de zsh |
| `programs.starship.enable` | Prompt personalizado (opcional) |
| `programs.<terminal>.enable` | Emuladores de terminal (kitty, alacritty, wezterm) |

**Ejemplo de aliases:**
```nix
programs.zsh.interactiveShellInit = ''
  alias ll="ls -la"
  alias gs="git status"
'';
```

---

### `network.nix` - Configuración de Red

**Propósito:** Gestión de configuración de red y servicios relacionados.

**Contenido:**
| Configuración | Descripción |
|---------------|-------------|
| `networking.computerName` | Nombre del computador (visible en red) |
| `networking.hostName` | Hostname del sistema |
| `networking.nameservers` | Servidores DNS |
| `services.openssh` | Configuración de SSH |
| `networking.firewall` | Firewall (opcional) |

**Configuración requerida:**
- Cambiar `Andrews-MacBook` por el nombre de tu equipo

---

### `git.nix` - Git Configuration

**Propósito:** Configuración global de Git.

**Contenido:**
| Configuración | Descripción |
|---------------|-------------|
| `programs.git.enable` | Habilita Git |
| `programs.git.userName` | Nombre de usuario para commits |
| `programs.git.userEmail` | Email para commits |
| `programs.git.aliases` | Aliases de Git |
| `programs.git.extraConfig` | Configuración adicional |
| `programs.git.signing` | Signing con GPG (opcional) |

**Configuración requerida:**
```nix
userName = "Tu Nombre";
userEmail = "tu@email.com";
```

**Aliases incluidos:**
| Alias | Comando |
|-------|---------|
| `co` | checkout |
| `br` | branch |
| `ci` | commit |
| `st` | status |
| `lg` | log --oneline --graph --decorate |

---

### `development.nix` - Herramientas de Desarrollo

**Propósito:** Instalación de herramientas, lenguajes y utilidades para desarrollo.

**Contenido:**

**Herramientas base incluidas:**
- `git` - Control de versiones
- `neovim` - Editor de texto
- `ripgrep` - Búsqueda de texto
- `fd` - Búsqueda de archivos
- `jq`, `yq` - Procesamiento de JSON/YAML
- `gnumake`, `cmake`, `just` - Build tools
- `curl`, `wget`, `httpie` - HTTP tools
- `postgresql`, `mysql` - Database tools
- `docker-compose` - Container tools

**Lenguajes (descomentar según necesidad):**
```nix
# Node.js
environment.systemPackages = [ pkgs.nodejs_20 pkgs.yarn pkgs.pnpm ];

# Python
environment.systemPackages = [ pkgs.python311 pkgs.pip ];

# Rust
environment.systemPackages = [ pkgs.rustup ];

# Go
environment.systemPackages = [ pkgs.go ];

# Java
environment.systemPackages = [ pkgs.jdk17 pkgs.maven ];
```

---

### `system.nix` - Preferencias del Sistema macOS

**Propósito:** Configuración de preferencias nativas de macOS.

**Contenido:**
| Configuración | Descripción |
|---------------|-------------|
| `system.keyboard` | Configuración de teclado |
| `system.trackpad` | Configuración de trackpad |
| `system.defaults.dock` | Preferencias del Dock |
| `system.defaults.finder` | Preferencias de Finder |
| `system.defaults.NSGlobalDomain` | Preferencias globales |

**Configuraciones incluidas:**
- Caps Lock → Control
- Auto-hide Dock
- Mostrar extensiones en Finder
- Desactivar autocorrecciones

---

## Principios de Diseño

### SOLID Aplicados

| Principio | Aplicación |
|-----------|------------|
| **Single Responsibility** | Cada módulo tiene una única responsabilidad |
| **Open/Closed** | Módulos abiertos a extensión, cerrados a modificación |
| **Liskov Substitution** | Módulos intercambiables sin efectos secundarios |
| **Interface Segregation** | Configuraciones específicas por dominio |
| **Dependency Inversion** | Dependencia de abstracciones (nix-darwin lib) |

### Ventajas de esta Estructura

1. **Mantenibilidad:** Cada módulo es independiente y fácil de entender
2. **Reusabilidad:** Módulos pueden copiarse entre proyectos
3. **Testabilidad:** Cada módulo puede validarse individualmente
4. **Escalabilidad:** Fácil agregar nuevos módulos
5. **Legibilidad:** Nombres descriptivos y organización clara

---

## Comandos Útiles

```bash
# Aplicar cambios
darwin-rebuild switch --flake .#Andrews-MacBook

# Construir sin aplicar
darwin-rebuild build --flake .#Andrews-MacBook

# Ver generaciones disponibles
darwin-rebuild list-generations

# Revertir a generación anterior
darwin-rebuild switch --generation <numero>

# Ver changelog de cambios
darwin-rebuild changelog

# Ver estado actual
git status  # si usas git para versionar la config
```

---

## Primeros Pasos

1. **Editar configuraciones requeridas:**
   - `git.nix` → userName y userEmail
   - `user.nix` → nombre de usuario
   - `network.nix` → computerName

2. **Personalizar según necesidades:**
   - `homebrew.nix` → agregar brews y casks
   - `development.nix` → descomentar lenguajes necesarios
   - `system.nix` → ajustar preferencias de macOS

3. **Aplicar configuración:**
   ```bash
   darwin-rebuild switch --flake .#Andrews-MacBook
   ```

---

## Recursos

- [nix-darwin Documentation](https://github.com/nix-darwin/nix-darwin)
- [NixOS Options Search](https://search.nixos.org/options)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)

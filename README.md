
# Notas

## pkgs

### commit exactos
> [!NOTE] Stable
> [nixhub](https://www.nixhub.io/) - para obtener el commit exacto

> [!NOTE] All
> [lazamar](https://lazamar.co.uk/)

```sh
sudo nix run nixpkgs#dysk
```

## TODO

- cambiar de
    - hyprland a mango
    - noctalia a waybar

## Apuntar en mis apuntes:

```sh
grep -rn "platformTheme\|QT_QPA_PLATFORMTHEME" /home/cris/.nixos-config
```

## formato de fecha

    %A, %d - %B - %Y | %H:%M:%S |

## CHECAR

### local/bin

```sh
mkdir -p ~/.local/bin
```

### NVIM

> [!WARNING]
> para **configurar, actualizar** cualquier parte de NVIM
> editar cualquer parte de: ~/.nixos-config/modules/nvim/nvim/

> [!NOTE]
> ***PARA QUE DE EFECTO***, hacer rebuild de nixos

## IMPORTANTE

### GDM (No recomendado para hyprland)

> [!WARNING] =====================
> Instalar GDM desde TTY, no desde grafico, por que te saca
>  - 1 salir de la session
>  - 2 entrar en modo TTY
> VA A TARDAR MUCHO EN ABRIR
> VA A TARDAR MUCHO EN ABRIR


### STEAM

> [!WARNING] =====================
> Al dar click o abrir por PRIMERA vez Steam
> VA A TARDAR MUCHO EN ABRIR

### Minibugs

- brave browser
    - bug:
        - si se abre por primera vez, y se abren otras ventanas, todas las otras ventanas, van a querer configurar brave, incluso si ya se ha configurado.
    - solucion: 
        - hay que abrirlo, SOLO UNA VENTANA
        - configurarlo {passwords, bookmarks, etc...}
        - cerrarlo
        - abrirlo de nuevo


## neovim

[neovimcraft](https://neovimcraft.com/)

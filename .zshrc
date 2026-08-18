# История команд
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # Общая история между терминалами
setopt HIST_IGNORE_DUPS       # Не писать дубликаты
setopt HIST_IGNORE_SPACE      # Игнорировать команды с пробелом в начале

# Автодополнение
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Инвариантность к регистру
zstyle ':completion:*' menu select

# Базовые алиасы
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias cp='cp -i'
alias mv='mv -i'

# Минималистичный промпт: Текущая папка синим цветом и значок >
PROMPT='%F{cyan}>%f '

# Подключаем автодополнение по истории (серый текст-подсказка)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Подключаем подсветку синтаксиса (зеленый/красный/ошибки на лету)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

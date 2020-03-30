# smbpasswd container

This is a small docker container to manage your password on a windows domain controller if you are on a non windows system

## Usage

### check when your password expires
```
> docker run -it --rm bitcloud/smbpassword check <domain controller> <username>
```

### update your password on the DC
```
> docker run -it --rm bitcloud/smbpassword change <domain controller> <username>
```

### create simple aliases
```
alias checkpw='docker run -it --rm bitcloud/smbpassword check <domain controller> <username>'
alias changepw='docker run -it --rm bitcloud/smbpassword change <domain controller> <username>'
```

after that you can simply do `checkpw` and `updatepw`

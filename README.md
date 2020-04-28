# packer-images

### I have been using [kiwi!](https://osinside.github.io/kiwi/) from opensuse for a while now. Since I started to work with packer I found packer is quite handy as well and it has some advantages.

__[packer.io!](https://www.packer.io/) allows me to:__ 
* my existing autoyast xml file to integrate it into packer template JSON file.
* add files and run shell scripts at the end of the autoyast installation but prior the entire system get imaged.
* "pause_before_connecting": "2m" - do make changes after autoyast installation in the real system e.g. change some file contents before packer shuts down the installed system to make image of it. Of course I could do the same using provisioner shell or file.

__The only disadvantage__ I found is: it is slower than kiwi in terms of building images. But packer supports way more different formats and platforms.


{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {

      overlay = final: prev: { blog_shamm_as = final.callPackage ./. { blog_src = self; }; };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      packages.x86_64-linux.blog_shamm_as = nixpkgs.legacyPackages.x86_64-linux.callPackage ./. {
        blog_src = self;
      };

      packages.x86_64-linux.default = self.packages.x86_64-linux.blog_shamm_as;
    };
}

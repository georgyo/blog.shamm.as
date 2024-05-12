{
  stdenv,
  hugo,
  blog_src ? builtins.fetchGit ./.,
}:

stdenv.mkDerivation {
  pname = "blog.shamm.as";
  version = blog_src.dirtyShortRev or blog_src.shortRev;

  src = blog_src;

  nativeBuildInputs = [ hugo ];

  buildPhase = ''
    hugo
  '';

  installPhase = ''
    mv public $out
  '';
}

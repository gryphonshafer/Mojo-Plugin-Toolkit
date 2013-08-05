use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Mojolicious::Plugin::ToolkitRenderer',
    AUTHOR           => q{Gryphon Shafer <gryphon@cpan.org>},
    VERSION_FROM     => 'lib/Mojolicious/Plugin/ToolkitRenderer.pm',
    ABSTRACT_FROM    => 'lib/Mojolicious/Plugin/ToolkitRenderer.pm',
    PL_FILES         => {},
    PREREQ_PM        => {
        'Mojolicious' => 3.43,
        'Test::More'  => 0,
        'Template'    => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Mojolicious-Plugin-ToolkitRenderer-*' },
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002 ? ('LICENSE'=> 'perl') : () ),
);

#!/usr/bin/env perl
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'             => 'Mojolicious::Plugin::ToolkitRenderer',
    'AUTHOR'           => 'Gryphon Shafer <gryphon@cpan.org>',
    'VERSION_FROM'     => 'lib/Mojolicious/Plugin/ToolkitRenderer.pm',
    'ABSTRACT_FROM'    => 'lib/Mojolicious/Plugin/ToolkitRenderer.pm',
    'PL_FILES'         => {},
    'MIN_PERL_VERSION' => '5.010',
    'PREREQ_PM'        => {
        'Mojolicious' => 3.43,
        'Template'    => 0,
        'Test::Most'  => 0,
    },
    'dist'  => { 'COMPRESS' => 'gzip -9f', 'SUFFIX' => 'gz' },
    'clean' => { 'FILES'    => 'Mojolicious-Plugin-ToolkitRenderer-*' },
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002 ? ( 'LICENSE' => 'perl' ) : () ),
    ( eval { ExtUtils::MakeMaker->VERSION(6.46) } ? ( 'META_MERGE' => {
        'meta-spec' => { version => 2 },
        'resources' => {
            'repository' => {
                'type' => 'git',
                'url'  => 'https://github.com/gryphonshafer/Mojo-Plugin-Toolkit.git',
                'web'  => 'https://github.com/gryphonshafer/Mojo-Plugin-Toolkit',
            },
        } } ) : ()
    ),
);

# NAME

Mojolicious::Plugin::ToolkitRenderer - Template Toolkit Renderer Mojolicious Plugin

# VERSION

version 1.08

[![Build Status](https://travis-ci.org/gryphonshafer/Mojo-Plugin-Toolkit.svg)](https://travis-ci.org/gryphonshafer/Mojo-Plugin-Toolkit)
[![Coverage Status](https://coveralls.io/repos/gryphonshafer/Mojo-Plugin-Toolkit/badge.png)](https://coveralls.io/r/gryphonshafer/Mojo-Plugin-Toolkit)

# SYNOPSIS

    # Mojolicious
    $self->plugin(
        'ToolkitRenderer',
        {
            settings => {
                inline_template => 'inline',
                controller      => 'c',
            },
            config => {
                RELATIVE  => 1,
                EVAL_PERL => 0,
                FILTERS   => { ucfirst => sub { return ucfirst shift } },
                ENCODING  => 'utf8',
            },
            context => sub {
                shift->define_vmethod( 'scalar', 'upper', sub { return uc shift } );
            },
        },
    );
    $self->renderer->default_handler('tt');

    # Mojolicious::Lite
    plugin( ToolkitRenderer => {
        settings => {
            inline_template => 'inline',
            controller      => 'c',
        },
        config => {
            RELATIVE  => 1,
            EVAL_PERL => 0,
            FILTERS   => { ucfirst => sub { return ucfirst shift } },
            ENCODING  => 'utf8',
        },
        context => sub {
            shift->define_vmethod( 'scalar', 'upper', sub { return uc shift } );
        },
    } );

# DESCRIPTION

This module is a Mojolicious plugin for easy use of [Template](https://metacpan.org/pod/Template) Toolkit. It
adds a "tt" handler and provides a "render\_tt" helper method. It allows for
inline TT and all the usual [Template](https://metacpan.org/pod/Template) complexities.

# SETUP

When setting up the plugin, you need to provide a hashref of settings that
are in 3 sections.

    {
        config   => {},
        settings => {},
        context  => {},
    }

## config

These are the configuration settings that get passed directly to [Template](https://metacpan.org/pod/Template)
within it's `new()` method. (See [Template](https://metacpan.org/pod/Template) documentation for details.)

## settings

These are settings specific to this plugin, all of which are optional.

    {
        inline_template => 'inline',
        controller      => 'c',
        error_handler   => sub {},
    }

The "inline\_template" setting lets you define what keyword you can use to
define an inline template. It defaults to "inline".

    $self->render_tt(
        inline => 'The answer to life, the [% universe | upper %], and [% everything.upper %] is [% answer %].',
        answer => 42, everything => 'everything', universe => 'universe',
    );

The "controller" settings lets your defined what keyword you can use within your
TT templates that will be a reference to the Mojolicious controller.

The "error\_handler" setting lets you provide an optional subroutine reference
that will get called if there is any TT errors. By default, when in development
mode, TT errors will surface in the normal Mojolicious helpful way (browser
page and logs). But you can override this.

    error_handler => sub {
        my ( $controller, $renderer, $app ) = @_;

        my $default_handler = $renderer->default_handler;
        $renderer->default_handler('ep');
        $controller->render_exception( Mojo::Exception->new( $template->error ) );
        $renderer->default_handler($default_handler);

        $controller->rendered(500);
    }

## context

This optional setting gives you access to setting vmethods and other things that
require TT's context.

    context => sub {
        my ($context) = @_;
        $context->define_vmethod( 'scalar', 'upper', sub { return uc shift } );
    },

# SEE ALSO

[Mojolicious](https://metacpan.org/pod/Mojolicious), [Mojolicious::Plugin](https://metacpan.org/pod/Mojolicious::Plugin), [Template](https://metacpan.org/pod/Template).

You can also look for additional information at:

- [GitHub](https://github.com/gryphonshafer/Mojo-Plugin-Toolkit)
- [CPAN](http://search.cpan.org/dist/Mojolicious-Plugin-ToolkitRenderer)
- [MetaCPAN](https://metacpan.org/pod/Mojolicious::Plugin::ToolkitRenderer)
- [AnnoCPAN](http://annocpan.org/dist/Mojolicious-Plugin-ToolkitRenderer)
- [Travis CI](https://travis-ci.org/gryphonshafer/Mojo-Plugin-Toolkit)
- [Coveralls](https://coveralls.io/r/gryphonshafer/Mojo-Plugin-Toolkit)
- [CPANTS](http://cpants.cpanauthors.org/dist/Mojo-Plugin-Toolkit)
- [CPAN Testers](http://www.cpantesters.org/distro/M/Mojo-Plugin-Toolkit.html)

# AUTHOR

Gryphon Shafer <gryphon@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2018 by Gryphon Shafer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

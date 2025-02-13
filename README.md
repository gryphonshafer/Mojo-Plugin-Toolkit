# NAME

Mojolicious::Plugin::ToolkitRenderer - Template Toolkit Renderer Mojolicious Plugin

# VERSION

version 1.13

[![test](https://github.com/gryphonshafer/Mojo-Plugin-Toolkit/workflows/test/badge.svg)](https://github.com/gryphonshafer/Mojo-Plugin-Toolkit/actions?query=workflow%3Atest)
[![codecov](https://codecov.io/gh/gryphonshafer/Mojo-Plugin-Toolkit/graph/badge.svg)](https://codecov.io/gh/gryphonshafer/Mojo-Plugin-Toolkit)

# SYNOPSIS

    # Simple Mojolicious
    $self->plugin('ToolkitRenderer');
    $self->renderer->default_handler('tt');

    # Customized Mojolicious
    $self->plugin(
        'ToolkitRenderer',
        {
            settings => {
                inline_template => 'inline',
                controller      => 'c',
            },
            config => {
                RELATIVE     => 1,
                EVAL_PERL    => 0,
                FILTERS      => { ucfirst => sub { return ucfirst shift } },
                ENCODING     => 'utf8',
                INCLUDE_PATH => $self->renderer->paths,
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
that will get called if there is any TT errors.

    error_handler => sub {
        my ( $controller, $renderer, $app, $template ) = @_;

        unless (
            $template->error and (
                $template->error eq 'file error - exception.html.tt: not found' or
                $template->error eq 'file error - exception.' . $app->mode . '.html.tt: not found'
            )
        ) {
            $$output = $template->error;
            $controller->res->headers->content_type('text/plain');

            $controller->log->error( $template->error );
            $controller->rendered(
                ( $template->error and $template->error =~ /not found/ ) ? 404 : 500
            );
        }
    }

## context

This optional setting gives you access to setting vmethods and other things that
require TT's context.

    context => sub {
        my ($context) = @_;
        $context->define_vmethod( 'scalar', 'upper', sub { return uc shift } );
    },

# SEE ALSO

[Mojolicious](https://metacpan.org/pod/Mojolicious), [Mojolicious::Plugin](https://metacpan.org/pod/Mojolicious%3A%3APlugin), [Template](https://metacpan.org/pod/Template).

You can also look for additional information at:

- [GitHub](https://github.com/gryphonshafer/Mojo-Plugin-Toolkit)
- [MetaCPAN](https://metacpan.org/pod/Mojolicious::Plugin::ToolkitRenderer)
- [GitHub Actions](https://github.com/gryphonshafer/Mojo-Plugin-Toolkit/actions)
- [Codecov](https://codecov.io/gh/gryphonshafer/Mojo-Plugin-Toolkit)
- [CPANTS](http://cpants.cpanauthors.org/dist/Mojo-Plugin-Toolkit)
- [CPAN Testers](http://www.cpantesters.org/distro/M/Mojo-Plugin-Toolkit.html)

# AUTHOR

Gryphon Shafer <gryphon@cpan.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2013-2050 by Gryphon Shafer.

This is free software, licensed under:

    The Artistic License 2.0 (GPL Compatible)

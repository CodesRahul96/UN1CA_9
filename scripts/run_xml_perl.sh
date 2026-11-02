#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
ROOT="$(dirname "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")")" || exit 1
XML_TOOLS="${TOOLS_DIR:-$ROOT/out/tools}"

# If host perl has XML::Parser available, use it directly!
if perl -MXML::Parser -e 1 2>/dev/null; then
    if [ "${1:-}" = --check ]; then
        exit 0
    fi
    exec perl "$@"
fi

# Fallback to setup_xml_parser.py if host perl lacks XML::Parser
if [ -f "$ROOT/scripts/setup_xml_parser.py" ]; then
    python3 "$ROOT/scripts/setup_xml_parser.py" --check --tools-dir "$XML_TOOLS" || exit 1
    if [ "${1:-}" = --check ]; then
        [ "$#" -eq 1 ] || exit 1
        exit 0
    fi
    unset PERL5OPT PERL5LIB PERL_MM_OPT PERL_MB_OPT PERL_LOCAL_LIB_ROOT PERL_UNICODE PERLIO
    XML_PREFIX="$XML_TOOLS/host-perl/perl-5.44.0-xml-parser-2.59"
    exec "$XML_PREFIX/bin/perl" -I "$XML_PREFIX/lib/perl5" "$@"
fi

echo "ERROR: XML::Parser for Perl is required. Please install libxml-parser-perl." >&2
exit 1

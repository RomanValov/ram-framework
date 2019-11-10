%{!?scm_version: %global scm_version %version}

Name:		ram-framework
Version:	0.4.10
Release:	1%{?dist}
Summary:	Framework to manage product state and configuration

License:	MIT
URL:		https://ram-framework.readthedocs.io/en/latest/
Source0:	https://github.com/bootforce-dev/ram-framework/archive/%{scm_version}/%{name}-%{scm_version}.tar.gz

BuildRequires:	python2-devel
BuildRequires:	python2-setuptools
#Requires:	python-iniparse
#Requires:	newt-python

BuildArch:	noarch

%description
Framework to manage product state and configuration

%prep
%autosetup -n %{name}-%{scm_version}

%build
%py2_build

%install
%py2_install
install -d %{buildroot}/%{_sysconfdir}/ram

%post
if [ "$1" -eq "1" ]; then
	ram paths insert %{_exec_prefix}/lib/ram >/dev/null
fi

%preun
if [ "$1" -eq "0" ]; then
	ram paths remove %{_exec_prefix}/lib/ram >/dev/null
fi

%files
%license LICENSE
%doc README.md
%dir %{_sysconfdir}/ram/
%ghost %attr(644,-,-) %config(noreplace) %{_sysconfdir}/ram/location.list
%ghost %attr(644,-,-) %config(noreplace) %{_sysconfdir}/ram/ram.conf
%{_sysconfdir}/bash_completion.d/ram.sh
%{_bindir}/*
%{python2_sitelib}/ram/
%{python2_sitelib}/ram_framework-%{version}-py?.?.egg-info/
%{_exec_prefix}/lib/ram/
%{_datadir}/ram/

%changelog
* Sun Nov 10 2019 Roman Valov <roman.valov@gmail.com> - 0.4.10-1
- Initial package

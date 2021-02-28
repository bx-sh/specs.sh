@spec.prints_specs_version_number() {
  expect { binSpec --version } toEqual "specs v0.6.0"
}
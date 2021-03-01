@spec.prints_specs_version_number() {
  expect { binSpecs --version } toEqual "specs v0.6.0"
}
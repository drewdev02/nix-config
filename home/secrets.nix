{ ... }:
{
  sops = {
    # NOTE: Use an absolute path here; `sops-nix` reads the key during activation.
    age.keyFile = "/Users/Andrew/.config/sops/age/keys.txt";

    # Add `defaultSopsFile` and `sops.secrets.<name>` entries here when you
    # create encrypted secret files for Home Manager to provision at runtime.
  };
}

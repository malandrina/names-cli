# Names CLI

Example usage:

```
./names_cli --male-only --begins-with "a,c,d,g,h,j,l,m,n,o,s,t,v"
--does-not-contain "dh,bh,gh,th,ph,ndr,jit,dutt,tya,lya" > result.txt
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add names_cli to your list of dependencies in `mix.exs`:

        def deps do
          [{:names_cli, "~> 0.0.1"}]
        end

  2. Ensure names_cli is started before your application:

        def application do
          [applications: [:names_cli]]
        end


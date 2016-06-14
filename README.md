# NameFinder

Example usage:

```
./name_finder --male --begins-with "a,c,d,g,h,j,l,m,n,o,s,t,v"
--does-not-contain "dh,bh,gh,th,ph,ndr,jit,dutt,tya,lya" > result.txt
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add name_finder to your list of dependencies in `mix.exs`:

        def deps do
          [{:name_finder, "~> 0.0.1"}]
        end

  2. Ensure name_finder is started before your application:

        def application do
          [applications: [:name_finder]]
        end


# OSC Reporting
This webapp aims to provide insight into Open OnDemand jobs

Under heavy development!

## Project Definition and Goals
This project exists to replicate and expand on the osc-systemstatus project [(Github)](https://github.com/OSC/osc-systemstatus) [(Webpage)](https://ondemand.osc.edu/pun/sys/systemstatus/clusters). 

New features in this project not in osc-systemstatus include:
* More representations of ood systems data.
  * This is an open and ongoing goal. Contributors will come up with their own new forms of representation.
  * Created widgets should be able to be loaded independent of each other so that they may be added to the dashboard
* Usage of the ood_core library instead of custom adapters.

## Getting started

Clone this repo

```
bin/bundle config path --local vendor/bundle
bin/setup
```

Ingest the data from `sacct` if you're able.
```
bin/rake db:ingest
```

## Recompling javascript and css

While developing in OnDemand, you'll likely have to recompile javascript and
css files.  This is partly because of how OnDemand boots apps and does not expect
the secondary server (the one updating these files automatically). The
other part is I haven't figured out how to get rails to do it with this
new asset pipeline.

Execute this rails task to run the asset pipeline. This will build new
javascript and css files. I like to set this as an alias I call `pc`.
```
bin/rails assets:precompile
```

## Database ingest

This currently only works with Slurm and users will have to be able 
to run `sacct` and view all jobs.

Run this rake task to populate your database.
```
bin/rake db:ingest
```


## Sacct help for reference

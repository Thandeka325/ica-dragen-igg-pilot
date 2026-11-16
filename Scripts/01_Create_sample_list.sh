find /cbio/projects/020/Thandeka/100_1K_GVCFs/1K_GVCFs \ #Path to downloaded gvcfs
    -name "*.hard-filtered.gvcf.gz" \
| xargs -n1 basename \
| sed 's/\.hard-filtered\.gvcf\.gz//' \
| sort > downloaded_samples.txt

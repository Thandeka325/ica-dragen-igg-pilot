awk '
BEGIN{
    OFS="\t"
    print "#FID","IID","SEX"
}
NR==FNR{
    sex[$1]=$2
    next
}
{
    if ($1 in sex) {
        code = (sex[$1]=="MALE") ? 1 : 2
        print $1,$1,code
    } else {
        print $1 > "missing_sex_samples.txt"
    }
}
' metadata/1kgp-sample-sex.tsv downloaded_samples.txt \
> version-1.genders.tsv

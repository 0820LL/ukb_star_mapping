// Declare syntax version
nextflow.enable.dsl=2

process STAR_ALIGN {

    container = "${projectDir}/../singularity-images/depot.galaxyproject.org-singularity-mulled-v2-1fa26d1ce03c295fe2fdcf85831a92fbcbd7e8c2-1df389393721fc66f3fd8778ad938ac711951107-0.img"

    input:
    path star_index
    path fastq

    output:
    path "*Log.final.out"
    path "*Log.out"
    path "*Log.progress.out"
    path "*d.out.bam"
    path "*toTranscriptome.out.bam"
    path "*.SJ.out.tab"

    script:
    """
    STAR \\
        --genomeDir $star_index \\
        --readFilesIn $fastq \\
        --outFileNamePrefix ${params.prefix}. \\
        --runThreadN ${params.threads_num} \\
        --quantMode TranscriptomeSAM  --readFilesCommand zcat  --outSAMtype BAM Unsorted
    cp *.out *.bam *.tab ${launchDir}/${params.outdir}/
    """
}

workflow{
    star_index = Channel.fromPath(params.star_index)
    fastq      = Channel.of(params.fastq1, params.fastq2).collect()
    STAR_ALIGN(star_index, fastq)
}


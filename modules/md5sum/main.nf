process MD5SUM {
    tag 'md5sum_list'
    label 'process_low'

    conda (params.enable_conda ? "python3" : latest)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/python3':
        'quay.io/biocontainers/python3' }"

    input:
    path any_file 

    output:
    path "md5sums_list.txt", emit: md5list

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    
    """
    md5sum * >> md5sums_list.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
         \$(echo \$md5sum --version | head -1 | sed 's/^.*md5sum (GNU coreutils)\s//')
    END_VERSIONS
    """
}

# Tagged release
if [[ ${GITHUB_REF} == refs/tags/* ]]; then
    # Strip git ref prefix from $VERSION
    TAGNAME=$(echo "${GITHUB_REF}" | sed -e 's,.*/\(.*\),\1,')
    # Strip "v" prefix from tag name
    VERSION=$(echo $TAGNAME | sed -e 's/^v//')
else
    VERSION=${GITHUB_SHA}
fi

echo "$VERSION"
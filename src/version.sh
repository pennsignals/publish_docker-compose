# Tagged release
if [[ ${{ github.ref }} == refs/tags/* ]]; then
    # Strip git ref prefix from $VERSION
    TAGNAME=$(echo "${{ github.ref }}" | sed -e 's,.*/\(.*\),\1,')
    # Strip "v" prefix from tag name
    VERSION=$(echo $TAGNAME | sed -e 's/^v//')
else
    VERSION=${{ github.sha }}
fi

echo "$VERSION"
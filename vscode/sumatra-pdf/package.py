"""Package this dependency-free local extension without downloading build tools."""
import json
from pathlib import Path
import sys
from zipfile import ZIP_DEFLATED, ZipFile

source = Path(__file__).resolve().parent
metadata = json.loads((source / "package.json").read_text())
target = Path(sys.argv[1]).resolve()
target.parent.mkdir(parents=True, exist_ok=True)
manifest = f'''<?xml version="1.0" encoding="utf-8"?>
<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011" xmlns:d="http://schemas.microsoft.com/developer/vsx-schema-design/2011">
<Metadata><Identity Language="en-US" Id="{metadata['name']}" Version="{metadata['version']}" Publisher="{metadata['publisher']}"/><DisplayName>{metadata['displayName']}</DisplayName><Description xml:space="preserve">{metadata['description']}</Description><Properties><Property Id="Microsoft.VisualStudio.Code.Engine" Value="{metadata['engines']['vscode']}"/><Property Id="Microsoft.VisualStudio.Code.ExtensionKind" Value="ui"/></Properties></Metadata>
<Installation><InstallationTarget Id="Microsoft.VisualStudio.Code"/></Installation><Dependencies/>
<Assets><Asset Type="Microsoft.VisualStudio.Code.Manifest" Path="extension/package.json" Addressable="true"/></Assets></PackageManifest>'''
types = '''<?xml version="1.0" encoding="utf-8"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="json" ContentType="application/json"/><Default Extension="js" ContentType="application/javascript"/><Default Extension="md" ContentType="text/markdown"/><Default Extension="vsixmanifest" ContentType="text/xml"/></Types>'''
with ZipFile(target, "w", ZIP_DEFLATED) as archive:
    archive.writestr("extension.vsixmanifest", manifest)
    archive.writestr("[Content_Types].xml", types)
    for name in ("package.json", "extension.js", "pdf-path.js", "README.md"):
        archive.write(source / name, "extension/" + name)
print(target)

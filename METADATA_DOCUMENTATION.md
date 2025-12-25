# Metadata Documentation

This repository includes comprehensive metadata files in multiple formats to provide detailed information about the project, facilitate citations, and enable integration with various platforms and tools.

## Available Metadata Files

### 1. METADATA.json
**Format:** JSON  
**Purpose:** Primary comprehensive metadata file  
**Contents:**
- Complete project information (name, version, description)
- Author and maintainer details
- Technical specifications (platforms, languages, dependencies)
- Features list for Windows and iOS components
- Component breakdown (scripts, binaries, modules)
- Licensing information
- Documentation references
- Support and contact information
- Usage instructions
- Target audience
- Warnings and notices

**Use case:** Machine-readable format for automated tools, package managers, and CI/CD pipelines.

### 2. METADATA.yml
**Format:** YAML  
**Purpose:** Human-readable metadata summary  
**Contents:**
- Condensed version of METADATA.json
- Key project information
- Essential technical details
- Licensing summary
- Documentation links

**Use case:** Easy manual inspection, configuration files, and human-readable documentation.

### 3. CITATION.cff
**Format:** Citation File Format (CFF)  
**Purpose:** Software citation standard  
**Contents:**
- Citation information for academic and research use
- Author details
- Version information
- References to upstream projects
- License information

**Use case:** 
- GitHub automatically recognizes this file and provides citation suggestions
- Academic papers and research documentation
- Software citation tracking
- DOI generation through GitHub-Zenodo integration

**Learn more:** [Citation File Format](https://citation-file-format.github.io/)

### 4. codemeta.json
**Format:** CodeMeta (JSON-LD)  
**Purpose:** Software metadata standard  
**Contents:**
- Structured metadata following CodeMeta schema
- Linked data format for semantic web integration
- Software requirements and dependencies
- Development status
- Target products and use cases

**Use case:**
- Software repositories and registries
- Research data management systems
- Semantic web applications
- Academic software cataloging

**Learn more:** [CodeMeta Project](https://codemeta.github.io/)

### 5. .zenodo.json
**Format:** Zenodo JSON  
**Purpose:** Zenodo integration metadata  
**Contents:**
- Metadata specifically formatted for Zenodo platform
- Creator and contributor information
- Keywords and classifications
- Related identifiers
- Access rights and licensing

**Use case:**
- Automatic archival on Zenodo
- DOI assignment for software releases
- Academic citations and references
- Long-term preservation

**Learn more:** [Zenodo GitHub Integration](https://docs.github.com/en/repositories/archiving-a-github-repository/referencing-and-citing-content)

## How to Use These Files

### For Users
- These files provide detailed information about the project
- Use CITATION.cff to properly cite this software in academic work
- Consult METADATA.json or METADATA.yml for technical specifications

### For Developers
- Reference metadata files when integrating this project
- Use for automated dependency management
- Leverage for CI/CD pipeline configuration

### For Researchers
- Cite using information from CITATION.cff
- DOI can be obtained through Zenodo integration
- CodeMeta provides semantic metadata for research data systems

### For Tool Integration
- Package managers can read METADATA.json
- Research repositories can import codemeta.json
- Citation managers can read CITATION.cff

## Updating Metadata

When updating the project, remember to update:
1. Version numbers in all metadata files
2. Date fields (last_updated, dateModified)
3. Feature lists when adding new functionality
4. Dependencies when adding/updating packages
5. Author/contributor information as needed

## Validation

All metadata files in this repository have been validated:
- JSON files validated with `python3 -m json.tool`
- YAML files validated with PyYAML
- CFF syntax follows Citation File Format specification
- CodeMeta follows JSON-LD and CodeMeta schema

## Standards and References

- **Citation File Format:** https://citation-file-format.github.io/
- **CodeMeta:** https://codemeta.github.io/
- **Zenodo:** https://zenodo.org/
- **JSON-LD:** https://json-ld.org/
- **SPDX License Identifiers:** https://spdx.org/licenses/

## Questions and Support

For questions about metadata files or to suggest improvements:
- Open an issue: https://github.com/wsx7524999/zapret-discord-youtube/issues
- Refer to upstream project: https://github.com/Flowseal/zapret-discord-youtube

---

Last updated: 2025-12-25

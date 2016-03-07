define ->
	# example input:
	# [0] Config.pm:324> INFO - This is Biber 2.1
	# [0] Config.pm:327> INFO - Logfile is 'output.blg'
	# [44] biber-darwin:276> INFO - === Thu Mar  3, 2016, 16:00:52
	# [45] Biber.pm:333> INFO - Reading 'output.bcf'
	# [148] Biber.pm:645> INFO - Found 1 citekeys in bib section 0
	# [168] Biber.pm:2977> INFO - Processing section 0
	# [184] Biber.pm:3115> INFO - Looking for bibtex format file 'bibliography.bib' for section 0
	# [186] bibtex.pm:1021> INFO - Decoding LaTeX character macros into UTF-8
	# [187] bibtex.pm:895> INFO - Found BibTeX data source 'bibliography.bib'
	# [187] Utils.pm:146> WARN - Entry small does not parse correctly
	# [187] Utils.pm:146> WARN - BibTeX subsystem: /.../.bib_46723.utf8, line 4, warning: possible runaway string started at line 3
	# [187] Utils.pm:162> ERROR - BibTeX subsystem: /.../.bib_46723.utf8, line 8, syntax error: at end of input, expected end of entry ("}" or ")") (skipping to next "@")
	# [188] Biber.pm:106> INFO - WARNINGS: 2
	# [188] Biber.pm:110> INFO - ERRORS: 1

	# [fullLine, lineNumber, messageType, message]
	LINE_SPLITTER_REGEX = /^\[(\d+)].*>\s(INFO|WARN|ERROR)\s-\s(.*)$/

	BiberLogParser = (text, options) ->
		@text = text.replace(/(\r\n)|\r/g, '\n')
		@options = options
		@lines = text.split('\n')

		@parse = () ->
			result = {
				all: [],
				errors: [],
				warnings: [],
				files: [],       # not used
				typesetting: []  # not used
			}
			@lines.forEach (line) ->
				match = line.match(LINE_SPLITTER_REGEX)
				if match
					[fullLine, lineNumber, messageType, message] = match
					newEntry = {
						file: null,
						level: messageType,
						message: message,
						line: null,
						raw: fullLine
					}
					result.all.push newEntry
					switch newEntry.level
						when 'ERROR' then result.errors.push newEntry
						when 'WARN'  then result.warnings.push newEntry
			return result

	return BiberLogParser

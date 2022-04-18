/*
 *  cef_file.h
 *
 *  Created by Chung-Kai Chen on 2011/4/29.
 *  Copyright 2011 Realtek, Inc.. All rights reserved.
 */

#include "config.h"
#include "system.h"
#include "coretypes.h"

#include "opts.h" /* for cl_decoded_option */

#define CEF_VERSION "CEF-ITV-1.1"
#define CEF_ITV_LINE_LENGTH 4096

extern FILE *cef_ovr_file;
extern FILE *cef_rpt_file;
extern FILE *cef_rpt_lto_file;
extern const char *full_progname;

extern bool do_flag_intervention (const char *input_path, const char *output_path); /* return true if CEF_INTERVENE is set and '.cef_ovr' is found */
extern bool do_flag_collecting (const char *input_path, const char *output_path); /* return true if CEF_COLLECT is set and '.cef_rpt' is found */
extern bool do_attr_intervention ();
extern bool do_attr_collecting ();

extern bool stop_flag_intervention; /* extra control for flag intervention */
extern bool stop_flag_collecting; /* extra control for flag collection */

extern void intervene_flags (struct cl_decoded_option **decoded_options, unsigned int *decoded_options_count, unsigned int lang_mask);
extern void collect_flags (struct cl_decoded_option **decoded_options, unsigned int *decoded_options_count);
extern int report_ending (int retval);

extern char *cef_cpl_tag; /* cef compliation tag -- used to identify a compilation */
extern char *get_absolute_path (const char *path);
extern bool cef_binary_read (FILE*, char *);
extern bool cef_binary_write (FILE* file, const char *format, ...) __attribute__((format(printf,2,3)));

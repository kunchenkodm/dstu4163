%% dstu4163.cls
%% Українські службові та ділові листи за ДСТУ 4163:2020
%% «Уніфікована система організаційно-розпорядчої документації.
%%  Вимоги до оформлення документів» (чинний з 01.09.2021).
%%
%% Copyright (C) 2026 Dmytro
%%
%% This work may be distributed and/or modified under the conditions of
%% the LaTeX Project Public License, either version 1.3c of this license
%% or (at your option) any later version. The latest version of this
%% license is in https://www.latex-project.org/lppl.txt
%%
%% Компіляція: LuaLaTeX (рекомендовано) або XeLaTeX.
%% Документація: doc/dstu4163-doc.pdf
%%
%% Посилання «п. X.Y» у коментарях — на пункти ДСТУ 4163:2020;
%% «реквізит NN» — на номер реквізиту за стандартом.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{dstu4163}[2026/11/18 v1.1 Ukrainian letters per DSTU 4163:2020]

\RequirePackage{iftex}
\ifTUTeX\else
  \ClassError{dstu4163}
    {Compile with LuaLaTeX or XeLaTeX}
    {The class needs fontspec (Times New Roman, Unicode Cyrillic).}
\fi

% ---------------------------------------------------------------------------
%  Опції класу: кегль (п. 7.2: 12–14 пт), інтервал тексту (п. 7.3: 1–1,5)
% ---------------------------------------------------------------------------
\newcommand\dstu@size{14}
\newcommand\dstu@spread{1}
\DeclareOption{12pt}{\renewcommand\dstu@size{12}}
\DeclareOption{13pt}{\renewcommand\dstu@size{13}}
\DeclareOption{14pt}{\renewcommand\dstu@size{14}}
\DeclareOption{single}{\renewcommand\dstu@spread{1}}
\DeclareOption{onehalf}{\renewcommand\dstu@spread{1.5}}
\DeclareOption*{\ClassWarning{dstu4163}{Unknown option `\CurrentOption' ignored}}
\ProcessOptions\relax

\LoadClass[12pt,a4paper]{article}

% Поля (п. 6.2): ліве 30, праве 10, верхнє і нижнє 20 мм
\RequirePackage[a4paper,left=30mm,right=10mm,top=20mm,bottom=20mm,
  headheight=16pt,headsep=5mm]{geometry}

% Шрифт (п. 7.2): Times New Roman; запасні — метрично сумісні
\RequirePackage{fontspec}
\IfFontExistsTF{Times New Roman}
  {\setmainfont{Times New Roman}}
  {\IfFontExistsTF{Liberation Serif}
     {\setmainfont{Liberation Serif}}
     {\setmainfont{TeX Gyre Termes}}}
\RequirePackage{babel}
\babelprovide[main,import]{ukrainian}
\RequirePackage{graphicx}

\ExplSyntaxOn

% ---------------------------------------------------------------------------
%  Кеглі. «Одинарний» інтервал = 1,15 кегля (як у Word для Times New Roman).
%  \small — довідкові дані (п. 7.2: 8–12 пт); \footnotesize — виконавець;
%  \large — назва виду документа (14–16 пт).
% ---------------------------------------------------------------------------
\cs_new_protected:Npn \__dstu_defsize:Nn #1 #2
  {
    \cs_set_protected:Npx #1
      {
        \exp_not:N \@setfontsize \exp_not:N #1
          { \fp_eval:n {#2} } { \fp_eval:n { round(1.15 * (#2), 2) } }
      }
  }
\__dstu_defsize:Nn \normalsize   { \dstu@size }
\__dstu_defsize:Nn \small        { \dstu@size - 2 }
\__dstu_defsize:Nn \footnotesize { 10 }
\__dstu_defsize:Nn \large        { \dstu@size + 2 }
\normalsize

% ---------------------------------------------------------------------------
%  Змінні
% ---------------------------------------------------------------------------
\tl_new:N \l__dstu_blank_tl
\tl_new:N \l__dstu_sender_tl
\tl_new:N \l__dstu_align_tl
\tl_new:N \l__dstu_spread_tl
\tl_new:N \l__dstu_gap_tl
\tl_new:N \l__dstu_sig_gap_tl
\bool_new:N \l__dstu_heading_bold_bool
\bool_new:N \l__dstu_form_bool
\bool_new:N \l__dstu_pagenum_bool
\dim_new:N \l__dstu_zone_dim
\dim_new:N \l__dstu_addr_offset_dim
\dim_new:N \l__dstu_addr_width_dim
\dim_new:N \l__dstu_access_offset_dim
\dim_new:N \l__dstu_sig_offset_dim
\dim_new:N \l__dstu_parindent_dim
\dim_new:N \l__dstu_attw_dim
\tl_new:N  \l__dstu_attlabel_tl
\box_new:N \l__dstu_arms_box
\box_new:N \l__dstu_head_box
\seq_new:N \g__dstu_addr_seq
\seq_new:N \g__dstu_exec_seq
\seq_new:N \l__dstu_contacts_seq
\tl_new:N  \g__dstu_applicant_tl
\bool_new:N \g__dstu_head_bool
\bool_new:N \g__dstu_after_sig_bool
\bool_new:N \g__dstu_after_closing_bool

% ---------------------------------------------------------------------------
%  Ключі \dstusetup
% ---------------------------------------------------------------------------
\keys_define:nn { dstu }
  {
    % --- Бланк ---------------------------------------------------------------
    blank .choices:nn = { corner , long , none }
      { \tl_set_eq:NN \l__dstu_blank_tl \l_keys_choice_tl } ,
    blank .initial:n = corner ,
    sender .choices:nn = { organisation , organization , person }
      { \tl_set_eq:NN \l__dstu_sender_tl \l_keys_choice_tl } ,
    sender .initial:n = organisation ,
    align .choices:nn = { center , flush }
      { \tl_set_eq:NN \l__dstu_align_tl \l_keys_choice_tl } ,
    align .initial:n = center ,
    form .bool_set:N = \l__dstu_form_bool ,
    form .default:n  = true ,
    arms       .tl_set:N = \l__dstu_arms_tl ,     % 01
    emblem     .tl_set:N = \l__dstu_arms_tl ,     % 02
    parent     .tl_set:N = \l__dstu_parent_tl ,   % 03
    name       .tl_set:N = \l__dstu_name_tl ,     % 04
    short-name .tl_set:N = \l__dstu_short_tl ,    % 04
    unit       .tl_set:N = \l__dstu_unit_tl ,     % 05
    address    .tl_set:N = \l__dstu_address_tl ,  % 06
    phone      .tl_set:N = \l__dstu_phone_tl ,    % 06
    email      .tl_set:N = \l__dstu_email_tl ,    % 06
    web        .tl_set:N = \l__dstu_web_tl ,      % 06
    extra      .tl_set:N = \l__dstu_extra_tl ,    % 06
    code       .tl_set:N = \l__dstu_code_tl ,     % 08
    % --- Документ ------------------------------------------------------------
    doctype          .tl_set:N = \l__dstu_doctype_tl ,      % 09
    doctype-subtitle .tl_set:N = \l__dstu_doctype_sub_tl ,
    date       .tl_set:N = \l__dstu_date_tl ,     % 10
    index      .tl_set:N = \l__dstu_index_tl ,    % 11
    ref-index  .tl_set:N = \l__dstu_refindex_tl , % 12
    ref-date   .tl_set:N = \l__dstu_refdate_tl ,  % 12
    access     .tl_set:N = \l__dstu_access_tl ,   % 14
    % --- Оформлення ----------------------------------------------------------
    text-spacing .tl_set:N = \l__dstu_spread_tl ,
    heading-bold .bool_set:N = \l__dstu_heading_bold_bool ,
    heading-bold .default:n = true ,
    page-numbers .bool_set:N = \l__dstu_pagenum_bool ,
    page-numbers .initial:n = true ,
    page-numbers .default:n = true ,
    gap           .tl_set:N = \l__dstu_gap_tl ,
    gap           .initial:n = 1 ,
    signature-gap .tl_set:N = \l__dstu_sig_gap_tl ,
    signature-gap .initial:n = 2 ,
    zone-width        .dim_set:N = \l__dstu_zone_dim ,
    zone-width        .initial:n = 73mm ,
    addressee-offset  .dim_set:N = \l__dstu_addr_offset_dim ,
    addressee-offset  .initial:n = 90mm ,
    addressee-width   .dim_set:N = \l__dstu_addr_width_dim ,
    addressee-width   .initial:n = 73mm ,
    access-offset     .dim_set:N = \l__dstu_access_offset_dim ,
    access-offset     .initial:n = 100mm ,
    signature-offset  .dim_set:N = \l__dstu_sig_offset_dim ,
    signature-offset  .initial:n = 125mm ,
    paragraph-indent  .dim_set:N = \l__dstu_parindent_dim ,
    paragraph-indent  .initial:n = 10mm ,
    % --- Мітки ---------------------------------------------------------------
    label-no          .tl_set:N = \l__dstu_lbl_no_tl ,
    label-no          .initial:n = № ,
    label-ref         .tl_set:N = \l__dstu_lbl_ref_tl ,
    label-ref         .initial:n = На~№ ,
    label-from        .tl_set:N = \l__dstu_lbl_from_tl ,
    label-from        .initial:n = від ,
    label-phone       .tl_set:N = \l__dstu_lbl_phone_tl ,
    label-phone       .initial:n = тел. ,
    label-email       .tl_set:N = \l__dstu_lbl_email_tl ,
    label-email       .initial:n = e-mail: ,
    label-code        .tl_set:N = \l__dstu_lbl_code_tl ,
    label-code        .initial:n = Код~ЄДРПОУ ,
    label-attachment  .tl_set:N = \l__dstu_lbl_att_tl ,
    label-attachment  .initial:n = Додаток: ,
    label-attachments .tl_set:N = \l__dstu_lbl_atts_tl ,
    label-attachments .initial:n = Додатки: ,
    label-seal        .tl_set:N = \l__dstu_lbl_seal_tl ,
    label-seal        .initial:n = М.~П. ,
  }
\tl_set:Nx \l__dstu_spread_tl { \dstu@spread }

% Порожні рядки між ключами допускаються: \par верхнього рівня = кома
\tl_new:N \l__dstu_setup_tl
\NewDocumentCommand \dstusetup { +m }
  {
    \tl_set:Nn \l__dstu_setup_tl {#1}
    \tl_replace_all:Nnn \l__dstu_setup_tl { \par } { , }
    \keys_set:nV { dstu } \l__dstu_setup_tl
  }

% ---------------------------------------------------------------------------
%  Допоміжні
% ---------------------------------------------------------------------------
\cs_new_protected:Npn \__dstu_gap:n #1
  { \par \vspace { \fp_eval:n {#1} \baselineskip } }
\cs_new_protected:Npn \__dstu_text_start:
  {
    \linespread { \l__dstu_spread_tl } \selectfont
    \setlength \parindent { \l__dstu_parindent_dim }
  }
\cs_new_protected:Npn \__dstu_text_end:
  { \par \linespread {1} \selectfont }
% Поле: значення або (у режимі form) лінія для заповнення від руки
\cs_new_protected:Npn \__dstu_field:Nn #1 #2
  { \tl_if_empty:NTF #1 { \underline { \hspace {#2} } } {#1} }
\cs_new_protected:Npn \__dstu_zone_align:
  { \str_if_eq:VnTF \l__dstu_align_tl { center } { \centering } { \raggedright } }
\prg_new_conditional:Npnn \__dstu_is_org: { p , T , F , TF }
  {
    \str_if_eq:VnTF \l__dstu_sender_tl { person }
      { \prg_return_false: } { \prg_return_true: }
  }

% ---- Логіка «зникання» реквізитів 10–12 ------------------------------------
% Рядок дати друкується, якщо задано дату чи індекс або ввімкнено form.
\prg_new_conditional:Npnn \__dstu_need_date: { p , T , F , TF }
  {
    \bool_lazy_any:nTF
      {
        { \l__dstu_form_bool }
        { ! \tl_if_empty_p:N \l__dstu_date_tl }
        { ! \tl_if_empty_p:N \l__dstu_index_tl }
      }
      { \prg_return_true: } { \prg_return_false: }
  }
% «№ …» — якщо задано індекс або (form і автор — юрособа).
\prg_new_conditional:Npnn \__dstu_need_index: { T , F , TF }
  {
    \bool_lazy_or:nnTF
      { ! \tl_if_empty_p:N \l__dstu_index_tl }
      { \bool_lazy_and_p:nn { \l__dstu_form_bool } { \__dstu_is_org_p: } }
      { \prg_return_true: } { \prg_return_false: }
  }
% «На № … від …» — якщо задано посилання або (form, юрособа, є бланк).
\prg_new_conditional:Npnn \__dstu_need_ref: { p , T , F , TF }
  {
    \bool_lazy_any:nTF
      {
        { ! \tl_if_empty_p:N \l__dstu_refindex_tl }
        { ! \tl_if_empty_p:N \l__dstu_refdate_tl }
        { \bool_lazy_all_p:n
            {
              { \l__dstu_form_bool }
              { \__dstu_is_org_p: }
              { ! \str_if_eq_p:Vn \l__dstu_blank_tl { none } }
            } }
      }
      { \prg_return_true: } { \prg_return_false: }
  }
\cs_new_protected:Npn \__dstu_date_part:
  {
    \bool_lazy_or:nnT
      { \l__dstu_form_bool } { ! \tl_if_empty_p:N \l__dstu_date_tl }
      { \__dstu_field:Nn \l__dstu_date_tl { 30mm } }
    \__dstu_need_index:T
      {
        \bool_lazy_or:nnT
          { \l__dstu_form_bool } { ! \tl_if_empty_p:N \l__dstu_date_tl }
          { \c_space_tl }
        \l__dstu_lbl_no_tl \c_space_tl
        \__dstu_field:Nn \l__dstu_index_tl { 30mm }
      }
  }
\cs_new_protected:Npn \__dstu_ref_part:
  {
    \l__dstu_lbl_ref_tl \c_space_tl \__dstu_field:Nn \l__dstu_refindex_tl { 22mm }
    \c_space_tl \l__dstu_lbl_from_tl \c_space_tl
    \__dstu_field:Nn \l__dstu_refdate_tl { 25mm }
  }

% ---- Назва виду документа (реквізит 09; п. 7.2, 7.4) -----------------------
\cs_new_protected:Npn \__dstu_doctype:
  {
    \tl_if_empty:NF \l__dstu_doctype_tl
      {
        { \large \bfseries \addfontfeature { LetterSpace = 12 }
          \MakeUppercase { \l__dstu_doctype_tl } \par }
        \tl_if_empty:NF \l__dstu_doctype_sub_tl
          { { \bfseries \l__dstu_doctype_sub_tl \par } }
      }
  }

% ---- Реквізити 01–08 --------------------------------------------------------
\cs_new_protected:Npn \__dstu_sender_names:
  {
    \tl_if_empty:NF \l__dstu_arms_tl { \l__dstu_arms_tl \par \vspace { 2mm } }
    \tl_if_empty:NF \l__dstu_parent_tl { { \small \l__dstu_parent_tl \par } }
    \tl_if_empty:NF \l__dstu_name_tl
      {
        { \bfseries
          \__dstu_is_org:TF
            { \MakeUppercase { \l__dstu_name_tl } } { \l__dstu_name_tl }
          \par }
      }
    \tl_if_empty:NF \l__dstu_short_tl { { \bfseries \l__dstu_short_tl \par } }
    \tl_if_empty:NF \l__dstu_unit_tl  { { \bfseries \l__dstu_unit_tl  \par } }
  }
\cs_new_protected:Npn \__dstu_build_contacts:
  {
    \seq_clear:N \l__dstu_contacts_seq
    \tl_if_empty:NF \l__dstu_phone_tl
      {
        \seq_put_right:Nx \l__dstu_contacts_seq
          { \exp_not:V \l__dstu_lbl_phone_tl \c_space_tl \exp_not:V \l__dstu_phone_tl }
      }
    \tl_if_empty:NF \l__dstu_email_tl
      {
        \seq_put_right:Nx \l__dstu_contacts_seq
          { \exp_not:V \l__dstu_lbl_email_tl \c_space_tl \exp_not:V \l__dstu_email_tl }
      }
    \tl_if_empty:NF \l__dstu_web_tl
      { \seq_put_right:Nx \l__dstu_contacts_seq { \exp_not:V \l__dstu_web_tl } }
  }
\cs_new_protected:Npn \__dstu_code_line:
  {
    \tl_if_empty:NF \l__dstu_code_tl
      {
        \__dstu_is_org:T { \l__dstu_lbl_code_tl \c_space_tl }
        \l__dstu_code_tl \par
      }
  }
% Кутовий бланк: кожний контакт окремим рядком
\cs_new_protected:Npn \__dstu_contacts_stacked:
  {
    \__dstu_build_contacts:
    {
      \small
      \tl_if_empty:NF \l__dstu_address_tl { \l__dstu_address_tl \par }
      \seq_map_inline:Nn \l__dstu_contacts_seq { ##1 \par }
      \tl_if_empty:NF \l__dstu_extra_tl { \l__dstu_extra_tl \par }
      \__dstu_code_line:
    }
  }
% Поздовжній бланк: контакти в рядок через кому
\cs_new_protected:Npn \__dstu_contacts_inline:
  {
    \__dstu_build_contacts:
    {
      \small
      \tl_if_empty:NF \l__dstu_address_tl { \l__dstu_address_tl \par }
      \seq_if_empty:NF \l__dstu_contacts_seq
        { \seq_use:Nn \l__dstu_contacts_seq { ,~ } \par }
      \tl_if_empty:NF \l__dstu_extra_tl { \l__dstu_extra_tl \par }
      \__dstu_code_line:
    }
  }

% ---- Права колонка: гриф (14), адресати (15), заявник ----------------------
\cs_new_protected:Npn \__dstu_addr_box:n #1
  {
    \group_begin:
      \setlength \parindent { 0pt }
      \setlength \parskip { 0.5 \baselineskip } % п. 7.3: частини — через 1,5 інт.
      #1 \par
    \group_end:
  }
\cs_new_protected:Npn \__dstu_right_column:
  {
    \raggedright
    \setlength \parindent { 0pt }
    \bool_set_false:N \l_tmpb_bool
    \tl_if_empty:NF \l__dstu_access_tl
      {
        \hspace* { \dim_eval:n { \l__dstu_access_offset_dim - \l__dstu_addr_offset_dim } }
        \parbox [t]
          { \dim_eval:n { \linewidth - \l__dstu_access_offset_dim + \l__dstu_addr_offset_dim } }
          { \raggedright \l__dstu_access_tl }
        \par
        \bool_set_true:N \l_tmpb_bool
      }
    \int_compare:nNnT { \seq_count:N \g__dstu_addr_seq } > { 4 }
      { \ClassWarning { dstu4163 } { More~than~4~addressees:~use~a~mailing~list~(p.~5.15) } }
    \seq_map_inline:Nn \g__dstu_addr_seq
      {
        \bool_if:NT \l_tmpb_bool { \__dstu_gap:n { \l__dstu_gap_tl } }
        \__dstu_addr_box:n {##1}
        \bool_set_true:N \l_tmpb_bool
      }
    \tl_if_empty:NF \g__dstu_applicant_tl
      {
        \bool_if:NT \l_tmpb_bool { \__dstu_gap:n { \l__dstu_gap_tl } }
        \__dstu_addr_box:n { \g__dstu_applicant_tl }
      }
  }

% ---- Кутовий бланк (і «без бланка») ----------------------------------------
\cs_new_protected:Npn \__dstu_head_corner:
  {
    \bool_set_false:N \l_tmpa_bool
    \str_if_eq:VnT \l__dstu_blank_tl { corner }
      { \tl_if_empty:NF \l__dstu_arms_tl { \bool_set_true:N \l_tmpa_bool } }
    \bool_if:NT \l_tmpa_bool
      { \hbox_set:Nn \l__dstu_arms_box { \l__dstu_arms_tl } }
    \par \noindent
    \begin{minipage}[t]{ \l__dstu_zone_dim }
      \vspace { 0pt }
      \__dstu_zone_align:
      \str_if_eq:VnT \l__dstu_blank_tl { corner }
        {
          \__dstu_sender_names:
          \__dstu_contacts_stacked:
          \tl_if_empty:NF \l__dstu_doctype_tl
            { \__dstu_gap:n { \l__dstu_gap_tl } \__dstu_doctype: }
          \bool_lazy_or:nnT { \__dstu_need_date_p: } { \__dstu_need_ref_p: }
            { \__dstu_gap:n { 0.5 } }
        }
      \__dstu_need_date:T { \__dstu_date_part: \par }
      \__dstu_need_ref:T { \vspace { 1mm } \__dstu_ref_part: \par }
    \end{minipage}
    \hspace { \dim_eval:n { \l__dstu_addr_offset_dim - \l__dstu_zone_dim } }
    \begin{minipage}[t]{ \l__dstu_addr_width_dim }
      \vspace { 0pt }
      \bool_if:NT \l_tmpa_bool
        {
          \vspace { \dim_eval:n
            { \box_ht:N \l__dstu_arms_box + \box_dp:N \l__dstu_arms_box + 2mm } }
        }
      \__dstu_right_column:
    \end{minipage}
    \par
    \str_if_eq:VnT \l__dstu_blank_tl { none }
      {
        \tl_if_empty:NF \l__dstu_doctype_tl
          {
            \__dstu_gap:n { \l__dstu_gap_tl }
            { \centering \__dstu_doctype: }
          }
      }
  }

% ---- Поздовжній бланк ------------------------------------------------------
\cs_new_protected:Npn \__dstu_head_long:
  {
    \par \noindent
    \begin{minipage}{ \linewidth }
      \centering
      \__dstu_sender_names:
      \vspace { 1mm }
      \__dstu_contacts_inline:
      \tl_if_empty:NF \l__dstu_doctype_tl
        { \__dstu_gap:n { \l__dstu_gap_tl } \__dstu_doctype: }
    \end{minipage}
    \bool_lazy_or:nnT { \__dstu_need_date_p: } { \__dstu_need_ref_p: }
      {
        \__dstu_gap:n { 0.5 }
        \noindent
        \makebox [ \l__dstu_addr_offset_dim ] [l] { \__dstu_date_part: }
        \__dstu_need_ref:T { \__dstu_ref_part: }
        \par
      }
    \bool_lazy_or:nnT
      { ! \seq_if_empty_p:N \g__dstu_addr_seq }
      { \bool_lazy_or_p:nn
          { ! \tl_if_empty_p:N \g__dstu_applicant_tl }
          { ! \tl_if_empty_p:N \l__dstu_access_tl } }
      {
        \__dstu_gap:n { \l__dstu_gap_tl }
        \noindent \hspace* { \l__dstu_addr_offset_dim }
        \begin{minipage}[t]{ \l__dstu_addr_width_dim }
          \vspace { 0pt }
          \__dstu_right_column:
        \end{minipage}
        \par
      }
  }

\cs_new_protected:Npn \__dstu_head_once:
  {
    \bool_if:NF \g__dstu_head_bool
      {
        \bool_gset_true:N \g__dstu_head_bool
        \__dstu_text_end:
        % Бланк збирається в коробку: якщо всі його реквізити порожні,
        % не друкуються ані він, ані інтервал після нього.
        \vbox_set:Nn \l__dstu_head_box
          {
            \str_if_eq:VnTF \l__dstu_blank_tl { long }
              { \__dstu_head_long: }
              { \__dstu_head_corner: }
          }
        \dim_compare:nNnT
          { \box_ht:N \l__dstu_head_box + \box_dp:N \l__dstu_head_box } > { 0pt }
          {
            \noindent \box_use_drop:N \l__dstu_head_box
            \__dstu_gap:n { \l__dstu_gap_tl }
          }
        \__dstu_text_start:
      }
  }

% ===========================================================================
%  Команди користувача. Порожній аргумент — команда нічого не друкує.
% ===========================================================================
% 15 Адресат: до чотирьох (п. 5.15). Порожній рядок — інтервал між частинами.
\NewDocumentCommand \addressee { +m }
  { \tl_if_blank:nF {#1} { \seq_gput_right:Nn \g__dstu_addr_seq {#1} } }
% Заявник / запитувач (звернення громадян, запити на інформацію)
\NewDocumentCommand \applicant { +m } { \tl_gset:Nn \g__dstu_applicant_tl {#1} }

\NewDocumentCommand \makeletterhead { } { \__dstu_head_once: }

% 19 Заголовок до тексту (п. 5.19, 7.6): без відступу, ≤ 73 мм, без крапки
\NewDocumentCommand \heading { +m }
  {
    \__dstu_head_once:
    \tl_if_blank:nF {#1}
      {
        \__dstu_text_end:
        \noindent
        \parbox [t] { \l__dstu_zone_dim }
          { \raggedright \bool_if:NT \l__dstu_heading_bold_bool { \bfseries } #1 }
        \par
        \__dstu_gap:n { \l__dstu_gap_tl }
        \__dstu_text_start:
      }
  }

% Звертання (етикет): по центру, кличний відмінок
\NewDocumentCommand \salutation { +m }
  {
    \__dstu_head_once:
    \tl_if_blank:nF {#1}
      {
        \__dstu_text_start:
        { \centering #1 \par }
        \__dstu_gap:n { 0.5 }
      }
  }

% 21 Відмітка про наявність додатків (п. 5.21)
\NewDocumentCommand \attachment { o +m }
  {
    \__dstu_head_once:
    \tl_if_blank:nF {#2}
      {
        \__dstu_text_end:
        \__dstu_gap:n { \l__dstu_gap_tl }
        \IfNoValueTF {#1}
          { \tl_set_eq:NN \l_tmpa_tl \l__dstu_lbl_att_tl }
          { \tl_set:Nn \l_tmpa_tl {#1} }
        \hbox_set:Nn \l_tmpa_box { \l_tmpa_tl \c_space_tl }
        \noindent
        \hangindent = \box_wd:N \l_tmpa_box
        \hangafter = 1 \relax
        \l_tmpa_tl \c_space_tl #2 \par
      }
  }
\newcounter{dstuatt}
\NewDocumentEnvironment { attachments } { o }
  {
    \__dstu_head_once:
    \__dstu_text_end:
    \__dstu_gap:n { \l__dstu_gap_tl }
    \IfNoValueTF {#1}
      { \tl_set_eq:NN \l__dstu_attlabel_tl \l__dstu_lbl_atts_tl }
      { \tl_set:Nn \l__dstu_attlabel_tl {#1} }
    \hbox_set:Nn \l_tmpa_box { \l__dstu_attlabel_tl \c_space_tl }
    \dim_set:Nn \l__dstu_attw_dim { \box_wd:N \l_tmpa_box }
    \begin{list} { \arabic{dstuatt}. }
      {
        \usecounter { dstuatt }
        \setlength \leftmargin { \dim_eval:n { \l__dstu_attw_dim + 1.6em } }
        \setlength \labelwidth { \leftmargin }
        \setlength \labelsep { 0pt }
        \setlength \itemindent { 0pt }
        \setlength \itemsep { 0pt }
        \setlength \parsep { 0pt }
        \setlength \topsep { 0pt }
        \setlength \partopsep { 0pt }
        \cs_set:Npn \makelabel ##1
          {
            \int_compare:nNnTF { \value { dstuatt } } = { 1 }
              { \makebox [ \l__dstu_attw_dim ] [l] { \l__dstu_attlabel_tl } }
              { \hspace* { \l__dstu_attw_dim } }
            ##1 \hfil
          }
      }
  }
  { \end{list} }

% Заключна формула ввічливості (необов'язкова; не є реквізитом ДСТУ)
\NewDocumentCommand \closing { +m }
  {
    \__dstu_head_once:
    \tl_if_blank:nF {#1}
      {
        \__dstu_text_end:
        \__dstu_gap:n { \l__dstu_gap_tl }
        \noindent #1 \par
        \bool_gset_true:N \g__dstu_after_closing_bool
      }
  }

% 22 Підпис (п. 5.22, 7.5, 7.7)
\tl_new:N \l__dstu_sigdate_tl
\tl_new:N \l__dstu_siggap_tl
\bool_new:N \l__dstu_sigseal_bool
\keys_define:nn { dstu / signature }
  {
    date .tl_set:N   = \l__dstu_sigdate_tl ,
    seal .bool_set:N = \l__dstu_sigseal_bool ,
    seal .default:n  = true ,
    gap  .tl_set:N   = \l__dstu_siggap_tl ,
  }
\NewDocumentCommand \signature { O{} +m +m }
  {
    \__dstu_head_once:
    \group_begin:
      \tl_clear:N \l__dstu_sigdate_tl
      \bool_set_false:N \l__dstu_sigseal_bool
      \bool_lazy_or:nnTF { \g__dstu_after_sig_bool } { \g__dstu_after_closing_bool }
        { \tl_set:Nn \l__dstu_siggap_tl { 1 } }
        { \tl_set_eq:NN \l__dstu_siggap_tl \l__dstu_sig_gap_tl }
      \keys_set:nn { dstu / signature } {#1}
      \__dstu_text_end:
      \__dstu_gap:n { \l__dstu_siggap_tl }
      \tl_set:Nn \l_tmpa_tl {#2}
      \tl_if_blank:VT \l_tmpa_tl { \tl_set_eq:NN \l_tmpa_tl \l__dstu_sigdate_tl }
      \hbox_set:Nn \l_tmpb_box {#3}
      \noindent
      \tl_if_blank:VTF \l_tmpa_tl
        { \hspace* { \l__dstu_zone_dim } }
        { \parbox [b] { \l__dstu_zone_dim } { \raggedright \l_tmpa_tl } }
      \dim_compare:nNnTF
        { \box_wd:N \l_tmpb_box } > { \linewidth - \l__dstu_sig_offset_dim }
        { \hfill \box_use:N \l_tmpb_box }
        {
          \hspace { \dim_eval:n { \l__dstu_sig_offset_dim - \l__dstu_zone_dim } }
          \box_use:N \l_tmpb_box \hfill
        }
      \par
      \bool_if:NT \l__dstu_sigseal_bool
        { \vspace { 0.5 \baselineskip } \noindent \l__dstu_lbl_seal_tl \par }
    \group_end:
    \bool_gset_true:N \g__dstu_after_sig_bool
    \bool_gset_false:N \g__dstu_after_closing_bool
  }
% Підписи осіб з однаковими посадами на одному рівні (п. 5.22)
\NewDocumentCommand \jointsignatures { +m +m +m +m }
  {
    \__dstu_head_once:
    \__dstu_text_end:
    \__dstu_gap:n { \l__dstu_sig_gap_tl }
    \noindent
    \parbox [t] { 0.47 \linewidth }
      { \raggedright #1 \par \vspace { 1.5 \baselineskip } \hfill #2 }
    \hfill
    \parbox [t] { 0.47 \linewidth }
      { \raggedright #3 \par \vspace { 1.5 \baselineskip } \hfill #4 }
    \par
    \bool_gset_true:N \g__dstu_after_sig_bool
  }

% 27 Відомості про виконавця (п. 5.27): лівий нижній кут останньої сторінки
\NewDocumentCommand \executor { +m }
  { \tl_if_blank:nF {#1} { \seq_gput_right:Nn \g__dstu_exec_seq {#1} } }
\cs_new_protected:Npn \__dstu_exec_out:
  {
    \seq_if_empty:NF \g__dstu_exec_seq
      {
        \__dstu_text_end:
        \vfill
        \noindent
        \parbox { \linewidth }
          { \footnotesize \raggedright \seq_use:Nn \g__dstu_exec_seq { \par } }
        \par
      }
  }
\AtEndDocument { \__dstu_exec_out: }

% ---------------------------------------------------------------------------
%  Дата (п. 5.10) та імена (п. 5.15, 5.22)
% ---------------------------------------------------------------------------
\cs_new:Npn \__dstu_two:n #1
  { \int_compare:nNnT { #1 } < { 10 } { 0 } \int_eval:n {#1} }
\cs_new:Npn \__dstu_month:n #1
  {
    \int_case:nn {#1}
      {
        {1}{січня} {2}{лютого} {3}{березня} {4}{квітня}
        {5}{травня} {6}{червня} {7}{липня} {8}{серпня}
        {9}{вересня} {10}{жовтня} {11}{листопада} {12}{грудня}
      }
  }
\NewExpandableDocumentCommand \dstudate { m m m }
  { \__dstu_two:n {#1} . \__dstu_two:n {#2} . #3 }
\NewExpandableDocumentCommand \dstudateverbal { s m m m }
  { \__dstu_two:n {#2} ~ \__dstu_month:n {#3} ~ #4 ~ \IfBooleanTF {#1} { р. } { року } }
\NewExpandableDocumentCommand \dstudateiso { m m m }
  { #3 . \__dstu_two:n {#2} . \__dstu_two:n {#1} }
\NewExpandableDocumentCommand \dstutoday { } { \dstudate { \day } { \month } { \year } }
\NewDocumentCommand \dstutodayverbal { s }
  { \IfBooleanTF {#1} { \dstudateverbal* } { \dstudateverbal } { \day } { \month } { \year } }

\NewDocumentCommand \surname { m } { \MakeUppercase {#1} }
\NewDocumentCommand \fullname { m m } { #1 ~ \MakeUppercase {#2} }

% ---------------------------------------------------------------------------
%  Нумерація сторінок (п. 7.10): з другої, посередині верхнього поля
% ---------------------------------------------------------------------------
\cs_set:Npn \ps@dstu
  {
    \cs_set:Npn \@oddhead
      { \hfil \bool_if:NT \l__dstu_pagenum_bool { \normalfont \normalsize \thepage } \hfil }
    \cs_set_eq:NN \@evenhead \@oddhead
    \cs_set:Npn \@oddfoot { }
    \cs_set_eq:NN \@evenfoot \@oddfoot
  }

\ExplSyntaxOff

\pagestyle{dstu}
\AtBeginDocument{%
  \thispagestyle{empty}%
  \setlength\parindent{10mm}%
  \setlength\parskip{0pt}%
  \setlength\emergencystretch{2em}%
  \raggedbottom
  \clubpenalty=10000 \widowpenalty=10000
}

\endinput

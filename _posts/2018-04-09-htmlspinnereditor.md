---
layout: post
category: swing
folder: HtmlSpinnerEditor
title: JSpinnerのエディタをJLabelに変更してHTMLを表示する
tags: [JSpinner, HTML]
author: aterai
pubdate: 2018-04-09T14:48:47+09:00
description: JSpinnerのListEditorをJLabelに変更してテキストをHTMLで表示します。
image: https://drive.google.com/uc?id=1SC3ViNpsTsIE2fgR1wtXawwKHpOD8P1PYg
comments: true
---
## 概要
`JSpinner`の`ListEditor`を`JLabel`に変更してテキストを`HTML`で表示します。

{% download https://drive.google.com/uc?id=1SC3ViNpsTsIE2fgR1wtXawwKHpOD8P1PYg %}

## サンプルコード
<pre class="prettyprint"><code>class HtmlListEditor extends JLabel implements ChangeListener {
  protected HtmlListEditor(JSpinner spinner) {
    super();
    if (!(spinner.getModel() instanceof SpinnerListModel)) {
      throw new IllegalArgumentException("model not a SpinnerListModel");
    }
    spinner.addChangeListener(this);

    setText(Objects.toString(spinner.getValue()));
    setBorder(BorderFactory.createEmptyBorder(0, 5, 0, 5));
    setOpaque(true);
    setBackground(Color.WHITE);
    setInheritsPopupMenu(true);

    String toolTipText = spinner.getToolTipText();
    if (Objects.nonNull(toolTipText)) {
      setToolTipText(toolTipText);
    }
  }
  @Override public void stateChanged(ChangeEvent e) {
    JSpinner spinner = (JSpinner) e.getSource();
    setText(Objects.toString(spinner.getValue()));
  }
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    d.width = 200;
    return d;
  }
  // @see javax/swing/JSpinner.DefaultEditor.html#dismiss(JSpinner)
  public void dismiss(JSpinner spinner) {
    spinner.removeChangeListener(this);
  }
}
</code></pre>

## 解説
- 上: `ListEditor(default)`
    - デフォルトの`ListEditor`を使用
    - エディタは`JFormattedTextField`なので、`HTML`は使用できない
- 下: `HtmlListEditor`
    - `JLabel`を継承する`HtmlListEditor`を作成して`JSpinner#setEditor(...)`で設定
    - `JLabel`がエディタになるので、`HTML`が使用可能で編集不可になる
    - `JSpinner.DefaultEditor`を継承していないので、`JSpinner#setEditor(...)`でエディタを変更する場合は、以下のように`JSpinner#removeChangeListener(...)`を呼んで`ChangeListener`を除去する必要がある
        
        <pre class="prettyprint"><code>JSpinner spinner = new JSpinner(new SpinnerListModel(items)) {
          @Override public void setEditor(JComponent editor) {
            JComponent oldEditor = getEditor();
            if (!editor.equals(oldEditor) &amp;&amp; oldEditor instanceof HtmlListEditor) {
              ((HtmlListEditor) oldEditor).dismiss(this);
            }
            super.setEditor(editor);
          }
        };
</code></pre>
    - * 参考リンク [#reference]
- [Java Swing How to - Create custom renderer for JSpinner to show customized content icons](http://www.java2s.com/Tutorials/Java/Swing_How_to/JSpinner/Create_custom_renderer_for_JSpinner_to_show_customized_content_icons.htm)
- [JComboBoxをJSpinnerの代わりに使用する](https://ateraimemo.com/Swing/SpinnerTextColor.html)
    - `JComboBox`を使用することで同様に`HTML`を表示可能だが、`LookAndFeel`が変化してしまう

<!-- dummy comment line for breaking list -->

## コメント

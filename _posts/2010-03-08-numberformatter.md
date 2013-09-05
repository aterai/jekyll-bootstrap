---
layout: post
title: JSpinnerで無効な値の入力を許可しない
category: swing
folder: NumberFormatter
tags: [JSpinner, JFormattedTextField, SpinnerNumberModel, DocumentListener, NumberFormatter]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-03-08

## JSpinnerで無効な値の入力を許可しない
`JSpinner`から`JFormattedTextField`を取得し、これに無効な値の入力を許可しないように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTQg6Td8tI/AAAAAAAAAfs/u5mXLfk3k64/s800/NumberFormatter.png)

### サンプルコード
<pre class="prettyprint"><code>JSpinner.NumberEditor editor = (JSpinner.NumberEditor)spinner.getEditor();
DefaultFormatter formatter = (DefaultFormatter) editor.getTextField().getFormatter();
formatter.setAllowsInvalid(false);
</code></pre>

### 解説
上記のサンプルでは、`DefaultFormatter#setAllowsInvalid(false)`などを設定した`DefaultFormatterFactory`を作成して、`JSpinner`から取得した`JFormattedTextField`に`setFormatterFactory`で追加しています。

- 上
    - `SpinnerNumberModel`を設定した通常の`JSpinner`
    - 別コンポーネントにフォーカスが移動するときに、値が有効か無効かを判断
- 中
    - `SpinnerNumberModel`を設定し、数値以外の無効な文字入力ができないようにした`JSpinner`
- 下
    - `SpinnerNumberModel`を設定した通常の`JSpinner`
    - 別コンポーネントにフォーカスが移動するときに、値が有効か無効かを判断
    - 無効な値の場合は、背景色を変更

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private static JSpinner makeSpinner2(SpinnerNumberModel m) {
  JSpinner s = new JSpinner(m);
  JSpinner.NumberEditor editor = (JSpinner.NumberEditor)s.getEditor();
  final JFormattedTextField ftf = (JFormattedTextField)editor.getTextField();
  ftf.setFormatterFactory(makeFFactory(m));
  ftf.getDocument().addDocumentListener(new DocumentListener() {
    private final Color color = new Color(255,200,200);
    @Override public void changedUpdate(DocumentEvent e) {
      updateEditValid();
    }
    @Override public void insertUpdate(DocumentEvent e) {
      updateEditValid();
    }
    @Override public void removeUpdate(DocumentEvent e) {
      updateEditValid();
    }
    private void updateEditValid() {
      EventQueue.invokeLater(new Runnable() {
        @Override public void run() {
          ftf.setBackground(ftf.isEditValid()?Color.WHITE:color);
        }
      });
    }
  });
  return s;
}
private static DefaultFormatterFactory makeFFactory(final SpinnerNumberModel m) {
  final NumberFormat format = new DecimalFormat("####0");
  NumberFormatter displayFormatter = new NumberFormatter(format);
  NumberFormatter editFormatter = new NumberFormatter(format) {
    @Override public Object stringToValue(String text) throws ParseException {
      try{
        Long.parseLong(text);
      }catch(NumberFormatException e) {
        throw new ParseException("xxx", 0);
      }
      Object o = format.parse(text);
      if(o instanceof Long) {
        Long val = (Long)format.parse(text);
        Long max = (Long)m.getMaximum();
        Long min = (Long)m.getMinimum();
        if(max.compareTo(val)&lt;0 || min.compareTo(val)&gt;0) {
          throw new ParseException("xxx", 0);
        }
        return val;
      }
      throw new ParseException("xxx", 0);
    }
  };
  //editFormatter.setAllowsInvalid(false);
  //editFormatter.setCommitsOnValidEdit(true);
  editFormatter.setValueClass(Long.class);
  return new DefaultFormatterFactory(displayFormatter, displayFormatter, editFormatter);
}
</code></pre>

### 参考リンク
- [JTextFieldの入力を数値に制限する](http://terai.xrea.jp/Swing/NumericTextField.html)

<!-- dummy comment line for breaking list -->

### コメント
- 無効な値が入力されたときの背景色の変更を`DocumentListener`で行うように修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-09-27 (火) 21:52:05
- メモ: [Bug ID: 6423494 SpinnerNumberModel should use getMinimum and getMaximum instead of fields](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6423494)、[SpinnerNumberModelに上限値を超える値を入力](http://terai.xrea.jp/Swing/SpinnerNumberModel.html) -- [aterai](http://terai.xrea.jp/aterai.html) 2011-09-27 (火) 22:12:46

<!-- dummy comment line for breaking list -->

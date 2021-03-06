---
layout: post
category: swing
folder: NumericTextField
title: JTextFieldの入力を数値に制限する
tags: [JTextField, JFormattedTextField, InputVerifier, DocumentFilter, PlainDocument]
author: aterai
pubdate: 2008-06-09T10:55:29+09:00
description: JTextFieldへのキー入力や貼り込みを数値のみに制限する方法をテストします。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTQjTks6aI/AAAAAAAAAfw/VCCb81SSh1s/s800/NumericTextField.png
comments: true
---
## 概要
`JTextField`へのキー入力や貼り込みを数値のみに制限する方法をテストします。ソースコードは、[Validating Text and Filtering Documents and Accessibility and the Java Access Bridge Tech Tips](http://web.archive.org/web/20090831154020/http://java.sun.com/developer/JDCTechTips/2005/tt0518.html)からの引用です。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTQjTks6aI/AAAAAAAAAfw/VCCb81SSh1s/s800/NumericTextField.png %}

## サンプルコード
<pre class="prettyprint"><code>JTextField textField1 = new JTextField("1000");
textField1.setHorizontalAlignment(JTextField.RIGHT);
textField1.setInputVerifier(new IntegerInputVerifier());

JTextField textField2 = new JTextField();
textField2.setDocument(new IntegerDocument());
textField2.setText("2000");

JTextField textField3 = new JTextField();
((AbstractDocument) textField3.getDocument()).setDocumentFilter(new IntegerDocumentFilter());
textField3.setText("3000");

JFormattedTextField textField4 = new JFormattedTextField();
textField4.setFormatterFactory(new NumberFormatterFactory());
textField4.setHorizontalAlignment(JTextField.RIGHT);
textField4.setValue(4000);

JSpinner spinner = new JSpinner(new SpinnerNumberModel(0, 0, Integer.MAX_VALUE, 1));
((JSpinner.NumberEditor) spinner.getEditor()).getFormat().setGroupingUsed(false);
spinner.setValue(5000);
</code></pre>

## 解説
- `1`:`JTextField` + `InputVerifier`
    - [Validating with Input Verifiers](http://web.archive.org/web/20090831154020/http://java.sun.com/developer/JDCTechTips/2005/tt0518.html)
    - `InputVerifier`を継承する`IntegerInputVerifier`を作成し、これを`JComponent#setInputVerifier(...)`メソッドで設定
    - 別コンポーネントにフォーカスが移動するときに、数値かどうか評価する
    - 数値以外、または結果が範囲外となる場合、テキストは変化せず`beep`音が鳴り、フォーカス移動がキャンセルされる

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class IntegerInputVerifier extends InputVerifier {
  @Override public boolean verify(JComponent c) {
    boolean verified = false;
    JTextField textField = (JTextField) c;
    try {
      Integer.parseInt(textField.getText());
      verified = true;
    } catch (NumberFormatException e) {
      UIManager.getLookAndFeel().provideErrorFeedback(c);
      //Toolkit.getDefaultToolkit().beep();
    }
    return verified;
  }
}
</code></pre>

- `2`:`JTextField` + `Custom Document`
    - [Validating with a Custom Document](http://web.archive.org/web/20090831154020/http://java.sun.com/developer/JDCTechTips/2005/tt0518.html)
    - `PlainDocument`を継承する`IntegerDocument`を作成し、これを`JTextComponent#setDocument(...)`メソッドで設定
    - キー入力、文字列のペーストが行われたときに、数値かどうか評価する
    - 入力が数値以外、または結果が範囲外となる場合、`beep`音が鳴り、テキストは変化しない

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class IntegerDocument extends PlainDocument {
  int currentValue = 0;
  public IntegerDocument() {
    super();
  }
  public int getValue() {
    return currentValue;
  }
  @Override public void insertString(int offset, String str, AttributeSet attributes)
        throws BadLocationException {
    if (str == null) {
      return;
    } else {
      String newValue;
      int length = getLength();
      if (length == 0) {
        newValue = str;
      } else {
        String currentContent = getText(0, length);
        StringBuffer currentBuffer = new StringBuffer(currentContent);
        currentBuffer.insert(offset, str);
        newValue = currentBuffer.toString();
      }
      currentValue = checkInput(newValue, offset);
      super.insertString(offset, str, attributes);
    }
  }
  @Override public void remove(int offset, int length) throws BadLocationException {
    int currentLength = getLength();
    String currentContent = getText(0, currentLength);
    String before = currentContent.substring(0, offset);
    String after = currentContent.substring(length + offset, currentLength);
    String newValue = before + after;
    currentValue = checkInput(newValue, offset);
    super.remove(offset, length);
  }
  private int checkInput(String proposedValue, int offset) throws BadLocationException {
    if (proposedValue.length() &gt; 0) {
      try {
        int newValue = Integer.parseInt(proposedValue);
        return newValue;
      } catch (NumberFormatException e) {
        throw new BadLocationException(proposedValue, offset);
      }
    } else {
      return 0;
    }
  }
}
</code></pre>

- `3`:`JTextField` + `DocumentFilter`
    - [Validating with a Document Filter](http://web.archive.org/web/20090831154020/http://java.sun.com/developer/JDCTechTips/2005/tt0518.html)
    - `DocumentFilter`を継承する`IntegerDocumentFilter`を作成し、これを`AbstractDocument#setDocumentFilter(...)`メソッドで設定
    - キー入力、文字列のペーストが行われたときに、数値かどうか評価する
    - 入力が数値以外、または結果が範囲外となる場合、`beep`音が鳴り、テキストは変化しない

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class IntegerDocumentFilter extends DocumentFilter {
  //int currentValue = 0;
  @Override public void insertString(DocumentFilter.FilterBypass fb,
      int offset, String string, AttributeSet attr) throws BadLocationException {
    if (string == null) {
      return;
    } else {
      replace(fb, offset, 0, string, attr);
    }
  }
  @Override public void remove(DocumentFilter.FilterBypass fb, int offset, int length)
      throws BadLocationException {
    replace(fb, offset, length, "", null);
  }
  @Override public void replace(DocumentFilter.FilterBypass fb, int offset, int length,
      String text, AttributeSet attrs) throws BadLocationException {
    Document doc = fb.getDocument();
    int currentLength = doc.getLength();
    String currentContent = doc.getText(0, currentLength);
    String before = currentContent.substring(0, offset);
    String after = currentContent.substring(length + offset, currentLength);
    String newValue = before + (text == null ? "" : text) + after;
    //currentValue =
    checkInput(newValue, offset);
    fb.replace(offset, length, text, attrs);
  }
  private static int checkInput(String proposedValue, int offset)
      throws BadLocationException {
    int newValue = 0;
    if (proposedValue.length() &gt; 0) {
      try {
        newValue = Integer.parseInt(proposedValue);
      } catch (NumberFormatException e) {
        throw new BadLocationException(proposedValue, offset);
      }
    }
    return newValue;
  }
}
</code></pre>

- `4`:`JFormattedTextField` + `DefaultFormatterFactory`
    - [How to Use Formatted Text Fields](https://docs.oracle.com/javase/tutorial/uiswing/components/formattedtextfield.html)
    - `DefaultFormatterFactory`を継承する`NumberFormatterFactory`を作成し、これを`JFormattedTextField#setFormatterFactory(...)`メソッドで設定
    - 別コンポーネントにフォーカスが移動するときに、数値かどうか評価する
    - 数値以外の場合、テキストは以前の値に`Undo`される
    - 数値が範囲外となる場合、最小値、または最大値に調整される
        - 注: [SpinnerNumberModelに上限値を超える値を入力](https://ateraimemo.com/Swing/SpinnerNumberModel.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class NumberFormatterFactory extends DefaultFormatterFactory {
  private static NumberFormatter numberFormatter = new NumberFormatter();
  static {
    numberFormatter.setValueClass(Integer.class);
    ((NumberFormat) numberFormatter.getFormat()).setGroupingUsed(false);
  }
  public NumberFormatterFactory() {
    super(numberFormatter, numberFormatter, numberFormatter);
  }
}
</code></pre>

- `5`:`JSpinner` + `SpinnerNumberModel`
    - `JFormattedTextField`の場合と同等

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Validating Text and Filtering Documents and Accessibility and the Java Access Bridge Tech Tips](http://web.archive.org/web/20090831154020/http://java.sun.com/developer/JDCTechTips/2005/tt0518.html)
- [How to Use Formatted Text Fields](https://docs.oracle.com/javase/tutorial/uiswing/components/formattedtextfield.html)
- [JSpinnerで無効な値の入力を許可しない](https://ateraimemo.com/Swing/NumberFormatter.html)

<!-- dummy comment line for breaking list -->

## コメント

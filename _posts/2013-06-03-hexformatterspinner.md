---
layout: post
title: JSpinnerの表記を16進数にする
category: swing
folder: HexFormatterSpinner
tags: [JSpinner, DefaultFormatter, Font]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-06-03

## JSpinnerの表記を16進数にする
`JSpinner`の表記を`16`進数にして、その`Unicode`コードポイントに割り当てられた文字を表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-eTZU_kuJGK4/UauUgRcPuTI/AAAAAAAABtc/7FNouA9JcLI/s800/HexFormatterSpinner.png)

### サンプルコード
<pre class="prettyprint"><code>DefaultFormatter hexformatter = new DefaultFormatter() {
  @Override public Object stringToValue(String text) throws ParseException {
    try{
      return Integer.valueOf(text, 16);
    }catch(NumberFormatException nfe) {
      throw new ParseException(text, 0);
    }
  }
  private final String MASK = "000000";
  @Override public String valueToString(Object value) throws ParseException {
    String str = MASK + Integer.toHexString((Integer)value).toUpperCase();
    int i = str.length() - MASK.length();
    return str.substring(i);
  }
};
hexformatter.setValueClass(Integer.class);
hexformatter.setOverwriteMode(true);

</code></pre>

### 解説
上記のサンプルでは、`DefaultFormatter#stringToValue(String)`と`DefaultFormatter#valueToString(Object)`をオーバーライドして、`0`から`0x10FFFF`までの整数を`16`進数で表示する`Formatter`を作成し、`JSpinner`に設定しています。

- - - -
- `JSpinner`から取得した数値(コードポイント)から文字を生成する時、サロゲートペアなどの基本多言語面(`BMP`)外に対応するために以下のような方法を使用しています。
    - 参考: [Sample Usage (The Java™ Tutorials > Internationalization > Working with Text)](http://docs.oracle.com/javase/tutorial/i18n/text/usage.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>int code = ((Integer)spinner.getValue()).intValue();
//char[] ca = Character.toChars(code);
String str = new String(Character.toChars(code));
</code></pre>

- - - -
[IPAmj明朝](http://mojikiban.ipa.go.jp/download.html)と[IPAex明朝フォント](http://ipafont.ipa.go.jp/)がインストールされている場合、その文字の形の違いを比較することができます。

- [IPAmj明朝フォントダウンロード　｜　IPA 文字情報基盤](http://mojikiban.ipa.go.jp/download.html)
- [IPAexフォント/IPAフォント](http://ipafont.ipa.go.jp/)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Fontのアウトラインを取得して文字列の内部を修飾する](http://terai.xrea.jp/Swing/LineSplittingLabel.html)
- [IPAmj明朝とIPAex明朝で形の違う字 NAOI's fotolife - 20130411131759](http://f.hatena.ne.jp/NAOI/20130411131759)

<!-- dummy comment line for breaking list -->

### コメント

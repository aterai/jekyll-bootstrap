---
layout: post
category: swing
folder: PaddingComboBox
title: JComboBoxの内余白
tags: [JComboBox, Border, LookAndFeel, JTextField]
author: aterai
pubdate: 2007-05-28T05:42:18+09:00
description: JComboBoxのエディタなどに内余白を設定します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTQv1E_b9I/AAAAAAAAAgE/nxvnwwFoDyU/s800/PaddingComboBox.png
comments: true
---
## 概要
`JComboBox`のエディタなどに内余白を設定します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTQv1E_b9I/AAAAAAAAAgE/nxvnwwFoDyU/s800/PaddingComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>static Border padding = BorderFactory.createEmptyBorder(0, 5, 0, 0);
// ...
DefaultComboBoxModel&lt;String&gt; model = new DefaultComboBoxModel&lt;&gt;();
model.addElement("aaaaaaaaaaaaaaaaaaaaaaaaa");
model.addElement("aaaabbb");
model.addElement("aaaabbbcc");
model.addElement("bbb1");
model.addElement("bbb12");

JComboBox&lt;String&gt; combo = new JComboBox&lt;String&gt;(model) {
  @Override public void updateUI() {
    setRenderer(null);
    super.updateUI();
    final ListCellRenderer&lt;? super String&gt; lcr = getRenderer();
    setRenderer(new ListCellRenderer&lt;String&gt;() {
      @Override public Component getListCellRendererComponent(
          JList&lt;? extends String&gt; list, String value, int index,
          boolean isSelected, boolean hasFocus) {
        JLabel l = (JLabel) lcr.getListCellRendererComponent(
            list, value, index, isSelected, hasFocus);
        l.setBorder(padding);
        return l;
      }
    });
    //XXX JDK 1.7.0 ?: ((JLabel) lcr).setBorder(padding);
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JComboBox`に、`Border`(`EmptyBorder`と`MatteBorder`を切り替え可能)を設定した`ListCellRenderer`を設定して、ドロップダウンリストの左余白をすこし広げています。`JComboBox`が編集不可の場合、エディタ部分もこの余白が自動的に適用されます。

- `0`:編集不可
    - `ListCellRenderer`で余白を指定

<!-- dummy comment line for breaking list -->

- - - -
以下は、`JComboBox`が編集可の場合のテストです。

- `1`: テキストフィールドの元`Border` + 任意の`Border`で余白を設定
    - `editor.setBorder(BorderFactory.createCompoundBorder(editor.getBorder(), padding));`
    - `JComboBox#getEditor()#getEditorComponent()`で取得した`JTextField`に余白を指定
    - `JDK 1.5`では余白を指定しても反映されない
    - `JDK 1.6`では取得した`JTextFieldをsetOpaque(true)`としないと背景色は反映されない

<!-- dummy comment line for breaking list -->

- `2`: テキストフィールドの元`Border`は無視して任意の`Border`のみで余白を設定
    - `editor.setBorder(padding);`
    - `JComboBox#getEditor()#getEditorComponent()`で取得した`JTextField`に余白を指定
    - `MetalLookAndFeel`でテキストフィールドの枠が描画できない

<!-- dummy comment line for breaking list -->

- - - -

- `3`: テキストフィールドの`Insets` + `5`ピクセル余白を設定
    - `editor.setMargin(new Insets(i.top,i.left+5,i.bottom,i.right));`
    - `MetalLookAndFeel`, `MotifLookAndFeel`, `WindowsLookAndFeel`などでは無効
    - `NimbusLookAndFeel`では有効だが、`JComboBox`の高さなども変化してしまう

<!-- dummy comment line for breaking list -->

- `4`: テキストフィールドの`Margin` + `5`ピクセル余白を設定
    - `editor.setMargin(new Insets(m.top,m.left+5,m.bottom,m.right));`
    - `MetalLookAndFeel`, `MotifLookAndFeel`, `WindowsLookAndFeel`などでは無効
    - `NimbusLookAndFeel`では有効

<!-- dummy comment line for breaking list -->

- - - -

- `5`: `JComboBox`の`Border` + 任意の`Border`で余白を`JComboBox`自身に設定
    - `JComboBox#setBorder()`で、元の`Border`の内側に余白を指定
    - `WindowsLookAndFeel`, `MotifLookAndFeel`で有効？
    - `MetalLookAndFeel`, `NimbusLookAndFeel`では、`JComboBox`の外側に余白が付く

<!-- dummy comment line for breaking list -->

- `6`: `JComboBox`の`Border` + 任意の`Border`で余白を`JComboBox`自身に設定
    - `JComboBox#setBorder()`で、元の`Border`の外側に余白を指定
    - `WindowsLookAndFeel`で余計な枠が表示される？

<!-- dummy comment line for breaking list -->

- - - -

- ~~その他にも、以下のように`UIManager`で余白を設定する方法もありますが、`LookAndFeel`によって対応が異なる？~~ `ComboBox.padding`は無くなっている？
    - `JComboBox`が編集可能の場合は、`ComboBox.editorBorder`が有効かもしれない
        
        <pre class="prettyprint"><code>// UIManager.put("ComboBox.padding", new InsetsUIResource(insets));
        UIManager.put("ComboBox.editorBorder", BorderFactory.createEmptyBorder(0, 5, 0, 0));
</code></pre>
- ~~上記のサンプルを、余白に色無しにして、`Ubuntu 7.04`(`GNOME 2.18.1`)、`JDK 1.6.0`で実行すると、以下のようになる~~

<!-- dummy comment line for breaking list -->
![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQyV_2TnI/AAAAAAAAAgI/yqGoi_zqsgI/s800/PaddingComboBox1.png)

- - - -
- `LookAndFeel`毎に`JComboBox`の余白の描画は異なるみたいなので、全部まとめて消すのは難しい？
- `BasicComboBoxUI`も、`ComboBox.buttonDarkShadow`が`ArrowButton`の三角とボタンの影に使われていて微妙
    - `BasicComboBoxUI#createArrowButton()`をオーバーライドして別途三角形アイコンを使う方がよさそう

<!-- dummy comment line for breaking list -->

コードは、[JComboBoxのBorderを変更する](https://ateraimemo.com/Swing/ComboBoxBorder.html)に移動。

## 参考リンク
- [JComboBoxにアイコンを表示](https://ateraimemo.com/Swing/IconComboBox.html)
- [JDK-4515838 Can't change the border of a JComboBox - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-4515838)
- [JDK-8179027 JComboBox too small under Windows LAF - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8179027)
    - 上記のスクリーンショットのような`WindowsLookAndFeel`で`JComboBox`の高さが小さすぎる件が修正される？

<!-- dummy comment line for breaking list -->

## コメント
- ~~なんだか、よく分からなくなってきましたorz。~~ `JDK 1.6.0_10-beta-b22`で、`BasicComboBoxUI`の`padding`にすこし修正が入っている？ようです。 -- *aterai* 2008-03-11 (火) 21:38:58
- `LookAndFeel`の切り替えなどを追加しました。 -- *aterai* 2008-04-02 (水) 20:08:01
- `1.7.0_06`で`Nimbus`などの`ComboBox.popupInsets`が修正？ [Bug ID: 7158712 Synth Property "ComboBox.popupInsets" is ignored](https://bugs.openjdk.java.net/browse/JDK-7158712) -- *aterai* 2012-08-15 (水) 13:58:34
- `Windows 7`の`LookAndFeel`、編集不可の`JComboBox`で、`((JLabel) combo.getRenderer() ).setBorder(padding);`が`JComboBox`本体に効かない(フォーカスのための`Border`のせい？)ため、セルレンダラーを作成して毎回余白を適用するように変更。このため、`Windows 7`の`LookAndFeel`では、`JComboBox`本体の点線によるフォーカス表示が無くなる。 -- *aterai* 2013-11-19 (火) 15:37:19

<!-- dummy comment line for breaking list -->

---
layout: post
category: swing
folder: ComboEditorPlaceholder
title: ComboBoxEditorにJLayerを設定してプレースホルダ文字列を表示する
tags: [JComboBox, ComboBoxEditor, JLayer]
author: aterai
pubdate: 2019-04-29T15:55:58+09:00
description: JComboBoxのComboBoxEditorにJLayerを設定し、そのテキストが空の場合はプレースホルダ文字列を表示します。
image: https://drive.google.com/uc?export=view&id=1tj1SR1p6B8munrw_eO-ktRIB0pyl4h2-kw
comments: true
---
## 概要
`JComboBox`の`ComboBoxEditor`に`JLayer`を設定し、そのテキストが空の場合はプレースホルダ文字列を表示します。

{% download https://drive.google.com/uc?export=view&id=1tj1SR1p6B8munrw_eO-ktRIB0pyl4h2-kw %}

## サンプルコード
<pre class="prettyprint"><code>combo2.setEditor(new BasicComboBoxEditor() {
  private Component editorComponent;

  @Override public Component getEditorComponent() {
    editorComponent = Optional.ofNullable(editorComponent)
        .orElseGet(() -&gt; {
          JTextComponent tc = (JTextComponent) super.getEditorComponent();
          return new JLayer&lt;&gt;(tc, new PlaceholderLayerUI&lt;&gt;("- Select type -"));
        });
    return editorComponent;
  }
});
combo2.setBorder(BorderFactory.createCompoundBorder(
    combo2.getBorder(), BorderFactory.createEmptyBorder(0, 2, 0, 0)));
</code></pre>

## 解説
- 上:
    - デフォルトの編集可能な`JComboBox`
    - 編集可能な`JComboBox`の場合は、[JComboBoxでアイテムが選択されていない場合のプレースホルダ文字列を設定する](https://ateraimemo.com/Swing/ComboBoxPlaceholder.html)のようにセルレンダラーを使用したプレースホルダ文字列の表示は不可
- 下:
    - 編集可能に設定した`JComboBox`にプレースホルダ文字列を表示する`JLayer`でラップした`JTextField`を生成する`ComboBoxEditor`を設定
    - `BasicComboBoxEditor#getEditorComponent()`はエディタとして`Component`を返すため、`JLayer`でラップした`JTextField`を使用可能
        - `BasicComboBoxEditor#createEditorComponent()`は`JTextField`を返すため、こちらをオーバーライドする場合は[JTextFieldにフォーカスと文字列が無い場合の表示](https://ateraimemo.com/Swing/GhostText.html)などのように`FocusListener`を使用する必要がある
    - `WindowsLookAndFeel`でエディタの内余白が適用されない場合がある？ため`JComboBox`本体の縁を変更
        - このため、他の`LookAndFeel`に切り替えると縁や内余白がおかしくなる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComboBoxでアイテムが選択されていない場合のプレースホルダ文字列を設定する](https://ateraimemo.com/Swing/ComboBoxPlaceholder.html)
- [ComboBoxEditorにJLayerを設定し入力の妥当性を表示する](https://ateraimemo.com/Swing/ComboBoxEditorVerifier.html)

<!-- dummy comment line for breaking list -->

## コメント

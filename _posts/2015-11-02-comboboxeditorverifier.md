---
layout: post
category: swing
folder: ComboBoxEditorVerifier
title: ComboBoxEditorにJLayerを設定し入力の妥当性を表示する
tags: [JComboBox, ComboBoxEditor, JLayer, InputVerifier]
author: aterai
pubdate: 2015-11-02T00:47:14+09:00
description: JComboBoxのComboBoxEditorにJLayerを設定し、その入力が妥当でない場合はアイコンを表示します。
image: https://lh3.googleusercontent.com/-4gsRLzrKTE0/VjYu_qwZ8pI/AAAAAAAAOFk/t0JvVmjMcjI/s800-Ic42/ComboBoxEditorVerifier.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2016/03/validating-input-on-editable-jcombobox.html
    lang: en
comments: true
---
## 概要
`JComboBox`の`ComboBoxEditor`に`JLayer`を設定し、その入力が妥当でない場合はアイコンを表示します。

{% download https://lh3.googleusercontent.com/-4gsRLzrKTE0/VjYu_qwZ8pI/AAAAAAAAOFk/t0JvVmjMcjI/s800-Ic42/ComboBoxEditorVerifier.png %}

## サンプルコード
<pre class="prettyprint"><code>comboBox.setEditable(true);
comboBox.setInputVerifier(new LengthInputVerifier());
comboBox.setEditor(new BasicComboBoxEditor() {
  private Component editorVerifier;
  @Override public Component getEditorComponent() {
    if (editorVerifier == null) {
      JTextComponent tc = (JTextComponent) super.getEditorComponent();
      editorVerifier = new JLayer&lt;JTextComponent&gt;(tc, new ValidationLayerUI());
    }
    return editorVerifier;
  }
});
</code></pre>

## 解説
- `6`文字以上入力すると赤い`×`アイコンを表示する`LayerUI`を作成
    - アイコンは[JLayerを使用したコンポーネントのデコレート方法](https://www.oracle.com/technetwork/jp/articles/java/jlayer-439461-ja.html)から引用
    - 入力の妥当性の検証自体は、`JComboBox`に設定した`InputVerifier`を使用
- `JComboBox`に`BasicComboBoxEditor#getEditorComponent()`をオーバーライドしてエディタコンポーネントを`JLayer`(上記の`LayerUI`を使用する)に変更した`ComboBoxEditor`を設定
    - `BasicComboBoxEditor#createEditorComponent()`をオーバーライドすることでエディタの`JTextField`に`JLayer`をする場合は、`BasicComboBoxEditor#getItem()`などのメソッドも修正する
    - `f.setName("ComboBox.textField");`とエディタに名前を設定しておくと、`NimbusLookAndFeel`などでフォーカス時の`Border`が正しく描画される
- <kbd>Enter</kbd>キーで`JComboBox`に編集中の文字列をアイテム追加する場合も`InputVerifier`で検証するように設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JComboBox&lt;String&gt; comboBox = new JComboBox&lt;String&gt;(model) {
  @Override public void updateUI() {
    super.updateUI();
    final JComboBox&lt;String&gt; cb = this;
    getActionMap().put("enterPressed", new AbstractAction() {
      @Override public void actionPerformed(ActionEvent e) {
        if (getInputVerifier().verify(cb)) {
          String str = Objects.toString(getEditor().getItem(), "");
          DefaultComboBoxModel&lt;String&gt; m =
            (DefaultComboBoxModel&lt;String&gt;) getModel();
          m.removeElement(str);
          m.insertElementAt(str, 0);
          if (m.getSize() &gt; 10) {
            m.removeElementAt(10);
          }
          setSelectedIndex(0);
        }
      }
    });
  }
};
</code></pre>

## 参考リンク
- [JLayerを使用したコンポーネントのデコレート方法](https://www.oracle.com/technetwork/jp/articles/java/jlayer-439461-ja.html)

<!-- dummy comment line for breaking list -->

## コメント

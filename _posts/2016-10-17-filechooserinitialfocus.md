---
layout: post
category: swing
folder: FileChooserInitialFocus
title: JFileChooserを開いたときの初期フォーカスを設定する
tags: [JFileChooser, NimbusLookAndFeel, Focus]
author: aterai
pubdate: 2016-10-17T00:34:37+09:00
description: NimbusLookAndFeelを使用しているJFileChooserを開いた場合、ファイル名表示用のJTextFieldに初期フォーカスを設定します。
image: https://drive.google.com/uc?id=1uW5FnfU0V3Yi9iBBMFV7uoN8M9IA2sskmg
comments: true
---
## 概要
`NimbusLookAndFeel`を使用している`JFileChooser`を開いた場合、ファイル名表示用の`JTextField`に初期フォーカスを設定します。

{% download https://drive.google.com/uc?id=1uW5FnfU0V3Yi9iBBMFV7uoN8M9IA2sskmg %}

## サンプルコード
<pre class="prettyprint"><code>fileChooser.setSelectedFile(new File(field.getText().trim()));
if (r2.isSelected()) {
  EventQueue.invokeLater(() -&gt; {
    findFileNameTextField(fileChooser).ifPresent(c -&gt; {
      ((JTextField) c).selectAll();
      c.requestFocusInWindow();
    });
  });
}
//...
private static Optional&lt;Component&gt; findFileNameTextField(JFileChooser fileChooser) {
  return Arrays.stream(fileChooser.getComponents())
  .flatMap(new Function&lt;Component, Stream&lt;Component&gt;&gt;() {
    @Override public Stream&lt;Component&gt; apply(Component c) {
      if (c instanceof Container) {
        Component[] sub = ((Container) c).getComponents();
        return sub.length == 0 ? Stream.of(c)
               : Arrays.stream(sub).flatMap(cc -&gt; apply(cc));
      } else {
        return Stream.of(c);
      }
    }
  })
  .filter(c -&gt; c instanceof JTextField)
  .findFirst();
}
</code></pre>

## 解説
上記のサンプルでは、`NimbusLookAndFeel`(`SynthLookAndFeel`)を使用している場合、`JFileChooser`を開いたときの初期フォーカスは、フォルダ選択用の`JComboBox`になっているので、これをファイル名表示用の`JTextField`に変更するテストを行っています。

- `JFileChooser`を開いた後でフォーカスを移動するため、`EventQueue.invokeLater(...)`を使用
- `JFileChooser`から直接ファイル名表示用の`JTextField`を取得することができないので、`Container#getComponents()`で子コンポーネントを検索している
- `MetalLookAndFeel`や`WindowsLookAndFeel`の場合、初期フォーカスはファイル名表示用の`JTextField`
    - `SynthLookAndFeel`のバグ？
- または、`PropertyChangeListener`、`AncestorListener`などを使用、`SynthFileChooserUIImpl#doAncestorChanged()`をオーバーライドする方法がある

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//TEST: PropertyChangeListener
fileChooser.addPropertyChangeListener(e -&gt; {
  String s = e.getPropertyName();
  if (s.equals("ancestor")) {
    if (e.getOldValue() == null &amp;&amp; e.getNewValue() != null) {
      // Ancestor was added, set initial focus
      findFileNameTextField(fileChooser).ifPresent(c -&gt; {
        ((JTextField) c).selectAll();
        c.requestFocusInWindow();
      });
    }
  }
});
</code></pre>

<pre class="prettyprint"><code>//TEST: AncestorListener
fileChooser.addAncestorListener(new AncestorListener() {
  @Override public void ancestorAdded(AncestorEvent e) {
    findFileNameTextField(fileChooser).ifPresent(c -&gt; {
      ((JTextField) c).selectAll();
      c.requestFocusInWindow();
    });
  }
  @Override public void ancestorMoved(AncestorEvent e) {}
  @Override public void ancestorRemoved(AncestorEvent e) {}
});
</code></pre>

<pre class="prettyprint"><code>//TEST: doAncestorChanged
fileChooser = new JFileChooser() {
  @Override public void updateUI() {
    super.updateUI();
    EventQueue.invokeLater(() -&gt; {
      setUI(new sun.swing.plaf.synth.SynthFileChooserUIImpl(fileChooser) {
        @Override protected void doAncestorChanged(PropertyChangeEvent e) {
          findFileNameTextField(fileChooser).ifPresent(c -&gt; {
            ((JTextField) c).selectAll();
            c.requestFocusInWindow();
          });
        }
      });
    });
  }
};
</code></pre>

## 参考リンク
- [Windowを開いたときのフォーカスを指定](https://ateraimemo.com/Swing/DefaultFocus.html)

<!-- dummy comment line for breaking list -->

## コメント

<?php

use Twig\Environment;
use Twig\Error\LoaderError;
use Twig\Error\RuntimeError;
use Twig\Extension\SandboxExtension;
use Twig\Markup;
use Twig\Sandbox\SecurityError;
use Twig\Sandbox\SecurityNotAllowedTagError;
use Twig\Sandbox\SecurityNotAllowedFilterError;
use Twig\Sandbox\SecurityNotAllowedFunctionError;
use Twig\Source;
use Twig\Template;

/* config/form_display/group_header.twig */
class __TwigTemplate_1a611db508023d208f28d0124b9ccbda extends Template
{
    private $source;
    private $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->parent = false;

        $this->blocks = [
        ];
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 1
        echo "<tr class=\"group-header group-header-";
        echo twig_escape_filter($this->env, ($context["group"] ?? null), "html", null, true);
        echo "\">
    <th colspan=\"";
        // line 2
        echo twig_escape_filter($this->env, ($context["colspan"] ?? null), "html", null, true);
        echo "\">
        ";
        // line 3
        echo twig_escape_filter($this->env, ($context["header_text"] ?? null), "html", null, true);
        echo "
    </th>
</tr>
";
    }

    public function getTemplateName()
    {
        return "config/form_display/group_header.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  46 => 3,  42 => 2,  37 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "config/form_display/group_header.twig", "C:\\Users\\godwi\\OneDrive\\Desktop\\sysfiles\\Software\\phpMyAdmin\\templates\\config\\form_display\\group_header.twig");
    }
}

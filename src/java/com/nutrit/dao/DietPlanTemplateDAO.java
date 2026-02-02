package com.nutrit.dao;

import com.nutrit.models.DietPlanTemplate;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * DAO for diet plan templates.
 * Refactored to use hardcoded data to strictly follow the 8-table schema.
 */
public class DietPlanTemplateDAO {

    private static final List<DietPlanTemplate> TEMPLATES = new ArrayList<>();

    static {
        TEMPLATES.add(createTemplate(1, "Perte de poids standard", "Perte de poids", "Réduction calorique", 1500, 
            "Avoine, Fruits", "Amandes", "Salade Poulet", "Yaourt", "Poisson Grillé, Légumes", "Tisane", 
            "Sans sucre ajouté", "Adultes", "Protéines: 30%, Glucides: 40%, Lipides: 30%", 7));
        
        TEMPLATES.add(createTemplate(2, "Prise de masse musculaire", "Sportif", "Hyperprotéiné", 2800, 
            "Oeufs, Pain complet", "Banane, Shaker", "Pâtes, Boeuf", "Fromage blanc", "Poulet, Riz, Brocoli", "Amandes", 
            "Riche en protéines", "Sportifs", "Protéines: 35%, Glucides: 45%, Lipides: 20%", 14));

        TEMPLATES.add(createTemplate(3, "Végétarien Équilibré", "Végétarien", "Équilibre", 2000, 
            "Fruit, Pain, Fromage", "Noix", "Légumineuses, Quinoa", "Fruit", "Tofu, Légumes variés", "Tisane", 
            "Végétarien", "Tous", "Végétal source de fer", 7));
    }

    private static DietPlanTemplate createTemplate(int id, String name, String category, String goal, int calories,
            String breakfast, String snack1, String lunch, String snack2, String dinner, String snack3,
            String restrictions, String suitable, String info, int duration) {
        DietPlanTemplate t = new DietPlanTemplate();
        t.setId(id);
        t.setName(name);
        t.setCategory(category);
        t.setTargetGoal(goal);
        t.setCaloriesPerDay(calories);
        t.setBreakfast(breakfast);
        t.setMorningSnack(snack1);
        t.setLunch(lunch);
        t.setAfternoonSnack(snack2);
        t.setDinner(dinner);
        t.setEveningSnack(snack3);
        t.setRestrictions(restrictions);
        t.setSuitableFor(suitable);
        t.setNutritionInfo(info);
        t.setDurationDays(duration);
        t.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        return t;
    }

    public List<DietPlanTemplate> getAllTemplates() {
        return new ArrayList<>(TEMPLATES);
    }

    public List<DietPlanTemplate> getTemplatesByCategory(String category) {
        return TEMPLATES.stream()
                .filter(t -> t.getCategory().equalsIgnoreCase(category))
                .collect(Collectors.toList());
    }

    public DietPlanTemplate getTemplateById(int id) {
        return TEMPLATES.stream().filter(t -> t.getId() == id).findFirst().orElse(null);
    }

    public List<DietPlanTemplate> searchTemplates(String query) {
        if (query == null || query.isEmpty()) return getAllTemplates();
        String lowerQuery = query.toLowerCase();
        return TEMPLATES.stream()
                .filter(t -> t.getName().toLowerCase().contains(lowerQuery) || 
                            t.getCategory().toLowerCase().contains(lowerQuery))
                .collect(Collectors.toList());
    }

    public List<DietPlanTemplate> getTemplatesByRestriction(String restriction) {
        if (restriction == null) return getAllTemplates();
        return TEMPLATES.stream()
                .filter(t -> t.getRestrictions().toLowerCase().contains(restriction.toLowerCase()))
                .collect(Collectors.toList());
    }

    public List<DietPlanTemplate> getTemplatesByCalorieRange(int minCalories, int maxCalories) {
        return TEMPLATES.stream()
                .filter(t -> t.getCaloriesPerDay() >= minCalories && t.getCaloriesPerDay() <= maxCalories)
                .collect(Collectors.toList());
    }

    public List<String> getAllCategories() {
        return TEMPLATES.stream().map(DietPlanTemplate::getCategory).distinct().collect(Collectors.toList());
    }
}

